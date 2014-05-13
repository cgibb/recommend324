users = Hash.new

users["Angelica"] = Hash["Blues Traveler", 3.5, "Broken Bells", 2.0,
                         "Norah Jones", 4.5, "Phoenix", 5.0,
                         "Slightly Stoopid", 1.5, "The Strokes", 2.5,
                         "Vampire Weekend", 3.0]

users["Bill"] =  Hash["Blues Traveler", 2.0, "Broken Bells", 3.5,
                      "Deadmau5", 4.0, "Phoenix", 5.0,
                      "Slightly Stoopid", 3.5,
                      "Vampire Weekend", 3.0]

users["Chan"] =  Hash["Blues Traveler", 5.0, "Broken Bells", 1.0,
                      "Deadmau5", 1.0, "Norah Jones", 3.0,
                      "Slightly Stoopid", 1.0, "Phoenix", 5.0]
users["Dan"] = Hash["Blues Traveler", 3.0, "Broken Bells", 4.0,
                    "Deadmau5", 4.5, "Phoenix", 3.0,
                    "Slightly Stoopid", 4.5, "The Strokes", 4.0,
                    "Vampire Weekend", 2.0]
users["Hailey"] = Hash["Broken Bells"=> 4.0, "Deadmau5"=> 1.0, 
                       "Norah Jones"=> 4.0,
                       "The Strokes"=> 4.0, "Vampire Weekend"=> 1.0]


users["Jordyn"] = Hash["Broken Bells"=> 4.5, "Deadmau5"=> 4.0, "Norah Jones"=> 5.0,
                       "Phoenix"=> 5.0, "Slightly Stoopid"=> 4.5,
                       "The Strokes"=> 4.0, "Vampire Weekend"=> 4.0
                      ]

users["Sam"] = Hash["Blues Traveler"=> 5.0, "Broken Bells"=> 2.0,
                    "Norah Jones"=> 3.0, "Phoenix"=> 5.0,
                    "Slightly Stoopid"=> 4.0, "The Strokes"=> 5.0
                   ]

users["Veronica"] = Hash["Blues Traveler"=> 3.0, "Norah Jones"=> 5.0,
                         "Phoenix"=> 4.0, "Slightly Stoopid"=> 2.5,
                         "The Strokes"=> 3.0
                        ]


def manhattan(rating1, rating2)
  distance = 0
  rating1.each_key {|key|
    if rating2.include?(key)
      distance += (rating1[key] - rating2[key]).abs
    end
  }
  return distance
end

def computeNearestNeighbor(username, users)
  distances = []
  users.each_key {|user|
    if user != username
      # r = 2 means Euclidean
      distance = minkowski(users[user], users[username], 2)
      distances.push([user, distance])
    end 
  }
  distances.sort_by!{|a| a[1]}
  return distances
end

def recommend(username, users)
  nearest = computeNearestNeighbor(username, users)[0][0]
  recommendations = []

  neighborRatings = users[nearest]
  userRatings = users[username]
  neighborRatings.each_key{ |artist|
    if !userRatings.include?(artist) 
      recommendations.push([artist, neighborRatings[artist]])
    end
  }
  return recommendations.sort_by{|a| a[1]}.reverse
end

def minkowski(rating1, rating2, r)
  if r == 0 then manhattan(rating1, rating2) end
  distance = 0
  commonRatings = false
  rating1.each_key {|key|
    if rating2.include?(key)
      distance += (rating1[key] - rating2[key]).abs ** r
      commonRatings = true
    end
  }
  if commonRatings 
    return distance ** 1/r
  else
    return 0
  end
end

# Needs to be fixed
def pearson(rating1, rating2)
  sum_xy, sum_x, sum_y, sum_x2, sum_y2 = 0, 0, 0, 0, 0
  n = 0

  rating1.each_key {|key|
    if rating2.include?(key)
      n += 1
      x = rating1[key]
      y = rating2[key]
      sum_xy += x * y
      sum_x += x
      sum_y += y
      sum_x2 += x**2
      sum_y2 += y**2
    end
  }
  denominator = Math.sqrt(sum_x2 - ((sum_x**2) / n)) * 
    Math.sqrt(sum_y2 - ((sum_y **2)) / n)
  if denominator == 0 then return 0
  else return (sum_xy - ((sum_x * sum_y) / n)) / denominator
  end
end
  
  
pearson(users["Angelica"], users["Hailey"]) 
