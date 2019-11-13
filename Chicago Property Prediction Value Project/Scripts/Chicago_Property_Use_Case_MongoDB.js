db.property0.find({})
   .projection({})
   .sort({_id:-1})
   .limit(100)
   
// We can provide the appropriate zip code with our predicted and actual value of the property there
// if a customer looks for a specific zip code with its property value by expecting:
// 1. the business score higher than 1;
// 2. total number of crimes lower than 1,500 with # of violent crimes lower than 800;
// 3. more than 3 schools around the property;
// 4. more than 2 grocery stores in this zip code with a total store area higher than 10,000 sqft.
db.property0.find(
    {$and:[
        {"# stores": {$gt: 2}}, {"total store sqft": {$gt: 10000}},
        {"# of schools": {$gt: 3}},{"# crimes": {$lt: 1500}},
        {"# violent crimes": {$lt: 800}}, {"business_score": {$gt: 1.00}}
    ]}).projection({"_id":0, "Zip_code":1, "predicted_aug_value":1, "actual_aug_value":1})
    
    
    