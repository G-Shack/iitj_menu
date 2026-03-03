import streamlit as st
import pandas as pd
import json
import re
from collections import defaultdict

# --------------------------------------------------
# Utility helpers
# --------------------------------------------------

def clean_text(val) -> str:
    """Normalize text coming from Excel cells."""
    if isinstance(val, pd.Series):
        if val.isna().all():
            return ""
        val = " ".join([str(v) for v in val.tolist() if not pd.isna(v)])
    if pd.isna(val):
        return ""
    text = str(val)
    text = text.replace("\n", " ")
    text = re.sub(r"\s+", " ", text)
    text = re.sub(r",\s*,+", ", ", text)
    text = text.strip(" ,")
    if text.lower() in {"-", "—", "na", "n/a", "none", "null"}:
        return ""
    return text


VALID_DAYS = {
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
}


def norm_day(val) -> str:
    text = str(val).strip().lower()
    for day in VALID_DAYS:
        if re.search(rf"\b{day}\b", text):
            return day
    return text


def norm_meal(val) -> str:
    text = str(val).strip().lower()
    text = re.sub(r"\s+", " ", text)
    text = text.replace("break fast", "breakfast")
    for meal in MEAL_META.keys():
        if re.search(rf"\b{meal}\b", text):
            return meal
    return text


def infer_day_meal_from_row(row: pd.Series) -> tuple[str, str]:
    values = [clean_text(v).lower() for v in row.values]
    joined = " ".join([v for v in values if v])

    day = ""
    meal = ""
    for d in VALID_DAYS:
        if re.search(rf"\b{d}\b", joined):
            day = d
            break

    for m in MEAL_META.keys():
        if re.search(rf"\b{m}\b", joined):
            meal = m
            break

    return day, meal


def empty_meal():
    return {
        "name": "",
        "icon": "",
        "start_time": "",
        "end_time": "",
        "veg": [],
        "non_veg": [],
        "jain": [],
        "special_note_veg": "",
        "special_note_non_veg": ""
    }


MEAL_META = {
    "breakfast": ("Breakfast", "sunrise", "7:30", "10:00"),
    "lunch": ("Lunch", "restaurant", "12:15", "14:45"),
    "snacks": ("Snacks", "local_cafe", "17:30", "18:30"),
    "dinner": ("Dinner", "dinner_dining", "20:00", "22:30"),
}

WEEKEND_MEAL_TIMES = {
    "breakfast": ("8:00", "10:30"),
    "lunch": ("12:30", "15:00"),
}


def apply_meal_times(day: str, meal: str) -> tuple[str, str]:
    if day in {"saturday", "sunday"} and meal in WEEKEND_MEAL_TIMES:
        return WEEKEND_MEAL_TIMES[meal]
    return MEAL_META[meal][2], MEAL_META[meal][3]

# --------------------------------------------------
# Streamlit UI
# --------------------------------------------------

st.set_page_config("Menu Excel → JSON", layout="wide")
st.title("🍽️ Hostel Menu Excel → JSON Generator")

veg_file = st.file_uploader("Upload Veg + Jain Excel", type=["xlsx"])
nonveg_file = st.file_uploader("Upload Non-Veg Excel", type=["xlsx"])

if not veg_file and not nonveg_file:
    st.warning("⚠️ Upload at least one Excel file (Veg or Non-Veg)")
    st.stop()

menu = defaultdict(dict)

# --------------------------------------------------
# Process Veg / Jain Excel
# --------------------------------------------------

if veg_file:
    veg_df = pd.read_excel(veg_file)
    veg_df.columns = [str(c).strip().lower() for c in veg_df.columns]

    # Normalize unnamed/blank headers
    veg_df = veg_df.rename(
        columns={
            c: "" for c in veg_df.columns if c.startswith("unnamed") or c == "nan"
        }
    )

    required = {"day", "meal", "veg", "jain"}
    veg_day_col = "day"
    veg_meal_col = "meal"
    veg_jain_col = "jain"
    veg_col_indices = []

    if not required.issubset(set(veg_df.columns)):
        if len(veg_df.columns) >= 4:
            veg_day_col = veg_df.columns[0]
            veg_meal_col = veg_df.columns[1]
            jain_candidates = [i for i, c in enumerate(veg_df.columns) if "jain" in c]
            veg_jain_col = veg_df.columns[jain_candidates[0]] if jain_candidates else veg_df.columns[-1]
        else:
            st.error(f"Veg Excel must contain columns: {required}")
            st.stop()

    # Build veg column indices by position to avoid duplicate header name expansion
    day_idx = next((i for i, c in enumerate(veg_df.columns) if c == veg_day_col), 0)
    meal_idx = next((i for i, c in enumerate(veg_df.columns) if c == veg_meal_col), 1)
    jain_idx = next((i for i, c in enumerate(veg_df.columns) if c == veg_jain_col), len(veg_df.columns) - 1)
    veg_col_indices = [
        i for i in range(len(veg_df.columns))
        if i not in {day_idx, meal_idx, jain_idx}
    ]

    # ✅ FIX: handle merged cells only for Day/Meal
    veg_df[veg_day_col] = veg_df[veg_day_col].ffill()
    veg_df[veg_meal_col] = veg_df[veg_meal_col].ffill()

    for _, row in veg_df.iterrows():
        day = norm_day(row[veg_day_col])
        meal = norm_meal(row[veg_meal_col])

        if day not in VALID_DAYS or meal not in MEAL_META:
            inferred_day, inferred_meal = infer_day_meal_from_row(row)
            if day not in VALID_DAYS and inferred_day:
                day = inferred_day
            if meal not in MEAL_META and inferred_meal:
                meal = inferred_meal

        if day not in VALID_DAYS:
            continue

        if meal not in MEAL_META:
            continue

        if meal not in menu[day]:
            name, icon, _, _ = MEAL_META[meal]
            start, end = apply_meal_times(day, meal)
            menu[day][meal] = empty_meal()
            menu[day][meal].update({
                "name": name,
                "icon": icon,
                "start_time": start,
                "end_time": end
            })

        veg_parts = [clean_text(row.iloc[i]) for i in veg_col_indices]
        veg_text = ", ".join([p for p in veg_parts if p])
        jain_text = clean_text(row.iloc[jain_idx])

        if veg_text:
            menu[day][meal]["veg"].append(veg_text)

        if jain_text:
            menu[day][meal]["jain"].append(jain_text)

# --------------------------------------------------
# Process Non-Veg Excel
# --------------------------------------------------

if nonveg_file:
    nonveg_df = pd.read_excel(nonveg_file)
    nonveg_df.columns = [str(c).strip().lower() for c in nonveg_df.columns]

    # Normalize unnamed/blank headers
    nonveg_df = nonveg_df.rename(
        columns={
            c: "" for c in nonveg_df.columns if c.startswith("unnamed") or c == "nan"
        }
    )

    if not {"day", "meal"}.issubset(set(nonveg_df.columns)):
        if len(nonveg_df.columns) >= 2:
            nonveg_df = nonveg_df.copy()
            nonveg_df = nonveg_df.rename(columns={nonveg_df.columns[0]: "day", nonveg_df.columns[1]: "meal"})
        else:
            st.error("Non-Veg Excel must contain 'Day' and 'Meal' columns")
            st.stop()

    # ✅ FIX: handle merged cells only for Day/Meal
    nonveg_df["day"] = nonveg_df["day"].ffill()
    nonveg_df["meal"] = nonveg_df["meal"].ffill()

    food_cols = [c for c in nonveg_df.columns if c not in {"day", "meal"}]

    for _, row in nonveg_df.iterrows():
        day = norm_day(row["day"])
        meal = norm_meal(row["meal"])

        if day not in VALID_DAYS or meal not in MEAL_META:
            inferred_day, inferred_meal = infer_day_meal_from_row(row)
            if day not in VALID_DAYS and inferred_day:
                day = inferred_day
            if meal not in MEAL_META and inferred_meal:
                meal = inferred_meal

        if day not in VALID_DAYS:
            continue

        if meal not in MEAL_META:
            continue

        if meal not in menu[day]:
            name, icon, _, _ = MEAL_META[meal]
            start, end = apply_meal_times(day, meal)
            menu[day][meal] = empty_meal()
            menu[day][meal].update({
                "name": name,
                "icon": icon,
                "start_time": start,
                "end_time": end
            })

        parts = []
        for col in food_cols:
            text = clean_text(row[col])
            if text:
                parts.append(text)

        if parts:
            menu[day][meal]["non_veg"].append(", ".join(parts))

# --------------------------------------------------
# Output
# --------------------------------------------------

final_json = json.dumps(menu, indent=4, ensure_ascii=False)

st.subheader("✅ Generated JSON")
st.code(final_json, language="json")

st.download_button(
    "⬇️ Download JSON",
    data=final_json,
    file_name="menu.json",
    mime="application/json"
)
