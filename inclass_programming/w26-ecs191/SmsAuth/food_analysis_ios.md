# iOS Food Tracking Dashboard View

Create the main dashboard view for an iOS food tracking app with the following specifications:

## UI Layout

### Top Section - Daily Metrics (3 circular progress indicators)

**Calories (Center, largest)**
- Display as "X kcal left of Y goal" 
- Progress ring fills as calories are consumed (inverse progress - starts full, empties as you eat)
- Color: Blue gradient
- Example: "1,200 kcal left of 2,500 goal"
- Ring should visually show remaining calories

**Protein (Left, medium)**
- Display as "Xg / Yg" (consumed / minimum target)
- Progress ring fills as you consume protein (normal progress towards goal)
- Color: Purple gradient
- Example: "90g / 150g"
- Ring fills up as you approach your minimum target

**Carbohydrates (Right, medium)**
- Display as "Xg / Yg" (consumed / daily budget)
- Informational only - just shows amount consumed
- Color: Orange gradient
- Example: "180g / 250g"
- Ring fills to show consumption relative to budget, but no special semantics

### Middle Section - Today's Log

Scrollable list of food entries, each showing:
- Small thumbnail image of the food
- Meal type and time (e.g., "Lunch • 12:30 PM")
- Food description (e.g., "Grilled Salmon Salad")
- Nutritional breakdown in compact format: "cal | P | C | F" (e.g., "450 cal | 30g P | 15g C | 22g F")
- Card-based design with rounded corners
- Dark theme with light text

### Bottom Navigation

Tab bar with 3 items:
- Dashboard (house icon) - currently selected
- Log (camera button, center, prominent) - primary action
- Profile (user icon)


## Camera Flow

When user taps the camera button:
1. Request camera permissions if needed
2. Show camera interface
3. After capture, get signed URL from `/api/signed-url`
4. Upload JPEG image directly to the signed URL using PUT
5. Call `/api/food-estimate/{image_id}` to get analysis
6. Show results and allow user to confirm/edit before adding to log
7. Add to today's log and update all metrics

## MealViewModel

This ViewModel will be an observable object and will have the
following published properties:
  - meals: [Meal]
  - goals: DailyMealGoals

and a function:
  - addMeal

## MealService model

Meal struct:
  - mealID
  - image
  - date (includes both date and time)
  - description
  - caloriesInKcal
  - carbohydratesInGrams
  - proteinInGrams

DailyMealGoals struct:
  - calories
  - carboydrates
  - protein

MealService (should be an actor to avoid data races):
  - func addMeal(from image: Image) (throw an exception if there is an error adding the meal)
  - func queryMeals() -> [Meal]
  - func update(meal: Meal)
  - func goals() -> DailyMealGoals
  - func update(goals: DailyMealGoals)

We will store 7 days worth of meals using a JSON file stored in the
file system and store images in the local file system as well. Make
sure that in our persisted meal data we have some way to lookup the
image.

We will also store our goals using a JSON file stored in the file
system. For default values use:
  - 2000 calorie
  - 100g protein
  - 150g carbohydrate

For now, let's just hard code some meals and store them in memory, we
can move to JSON after we implement the addMeal function, which we
will do later.

## User Settings

User should be able to configure:
- Daily calorie goal (default: 2500)
- Minimum protein target (default: 150g)
- Carbohydrate budget (default: 250g)

Store these in UserDefaults for now.

## Technical Requirements

- Use SwiftUI for all views
- Use SF Symbols for icons where appropriate
- Handle loading states during API calls
- Error handling for failed uploads or analysis
- Local storage for today's food log (can use simple JSON file or UserDefaults for prototype)

## Visual Design Notes

- Modern, clean interface with good spacing
- Circular progress indicators should have a subtle glow/gradient effect
- Round corners throughout (16pt radius for cards)
- Bottom tab bar should be prominent with the camera button slightly elevated or larger

Please implement this view with placeholder data first, then we can wire up the actual API integration.
