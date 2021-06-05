List<String> sections = [
  'Goals',
  'Personal Growth',
  'Physical health and Nutrition',
  'University and college',
  'Movement and sports',
  'Stress and anxiety',
  'Sleep and rest',
  'Work and productivity',
];
List<String> items = [
  'Goal Planner',
  'Books',
  'Audio',
  'Blog',
  'Motivational Audio',
  'Bianural Beats',
  'Visualization'
];
List<String> _items = [...items];
 List<List<String>> categories = [
   [..._items,],
   [..._items..removeAt(0),],
   [..._items,],
   [..._items,],
   [..._items,],
   [..._items,],
   [..._items,],
   [..._items,],
 ];
