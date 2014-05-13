


def adjCosineSimilarity(band1, band2, userRatings)
  averages = {}
  userRatings.each {|key, ratings|
    averages[key] = (Float(ratings.values.inject(:+)) / ratings.values.length)
  }
  num, dem1, dem2 = 0, 0, 0
  
  userRatings.each{ |user, ratings|
    if ratings.include?(band1) && ratings.include?(band2)
      avg = averages[user]
      num += (ratings[band1] - avg) * (ratings[band2] - avg)
      dem1 += (ratings[band1] - avg) ** 2
      dem2 += (ratings[band2] - avg) ** 2
    end
  }
  
  return num / (Math.sqrt(dem1) * Math.sqrt(dem2))
end
