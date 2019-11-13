// 1. List total number of customers living in california ?
db.customers.find({ District: "California" } ).count()


// 2. List all movies that are rated NC-17
db.films.find({ Rating: "NC-17" })

// 3. List the count of movies by category
db.films.aggregate([
    {
        $group: { _id: "$Category",
                  count: {$sum: 1}
            
                }
    }])
// db.films.find({ Category: "Travel" }).count()

// 4. Find the top 2 movies with movie length greater than 25mins and which has commentaries as a special feature
db.films.find(
    {$and: [
        {"Length": {$gt: "25"}}, {"Special Features": {$regex: "Commentaries"}}
    ]}).limit(2)

db.films.find(
    {"Length": {$gt: "25"}, "Special Features": {$regex: "Commentaries"}}
    ).sort({Length:-1}).limit(2)
    


// 5. Provide 2 additional queries and indicate the specific business use cases they address

