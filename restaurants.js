db.restaurants.find({})
   .projection({})
   .sort({_id:-1})
   .limit(100)
   

db.restaurants.insertOne(
   { item: "DDAI", qty: 100, tags: ["dummy & yellow"], size: { h: 20, w: 19, uom: "inches" }, Status: {'Z'}}
)

db.restaurants.find({status: "Z"})