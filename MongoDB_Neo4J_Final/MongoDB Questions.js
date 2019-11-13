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

// List ordered by _id, first appeared first results come:
db.films.find(
    {$and: [
        {"Length": {$gt: "25"}}, {"Special Features": {$regex: "Commentaries"}}
    ]}).limit(2)

// Ordered by length from the longest length to the shorter length(99 mins come first):
db.films.find(
    {"Length": {$gt: "25"}, "Special Features": {$regex: "Commentaries"}}
    ).sort({Length: -1}).limit(2)
    
// Ordered by length from the shortest length to longer length(46 mins come first):
db.films.find(
    {"Length": {$gt: "25"}, "Special Features": {$regex: "Commentaries"}}
    ).sort({Length: 1}).limit(2)
    

// 5. Provide 2 additional queries and indicate the specific business use cases they address

// Use case 1:
// Show the cutomer's full name (concatenated the first name and last name into one field) if this customer is in the US 
// and phone number includes 26
db.customers.aggregate([{$match:{$and:[{Country:"United States" }, {Phone:{$regex: "26"}}]}}, {$project: 
{ "Full Name": { $concat: [ "$First Name", " ", "$Last Name" ]}}}])

// Use case 2:
// List 10 movies in the music category ordered by length from the shortest to longer length movies
db.films.find({Category:"Music"}).sort({Length: 1}).limit(10)


