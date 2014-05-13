  
# 
#  Naive Bayes Classifier chapter 6
#


# _____________________________________________________________________

class Classifier
	# A port to Ruby. Changed to just have bucket as input.
	def initialize(files, number, dataFormat)
        total = 0
        classes = {}
        counts = {}
        
        # reading the data in from the file
        
        @format = dataFormat.strip.split('\t')
        @prior = {}
        @conditional = {}
        # for each of the buckets numbered 1 through 10:
        (1...11).each do |i|
			if (i != number)
			category = 0
			bucket = files + "-" + i.to_s.rjust(2, "0")
            lines = IO.readlines(bucket)
            lines.each { |line|
                fields = line.strip.split('\t')
                ignore = []
                vector = []
				Range.new(1, fields.length).each { |i|
                    if @format[i] == 'num'
                        vector.append(float(fields[i]))
                    elsif @format[i] == 'attr'
                        vector.append(fields[i])                           
                    elsif @format[i] == 'comment'
                        ignore.append(fields[i])
                    elsif @format[i] == 'class'
                        category = fields[i]
					end
				}
                # now process this instance
                total += 1
				if (! classes.member?(category))
					classes[category] = 0
				end
				if (! counts.member?(category))
					counts[category] = {};
				end
                classes[category] += 1
                # now process each attribute of the instance
                col = 0
                vector.each { |columnValue|
                    col += 1
                    counts[category].setdefault(col, {})
                    counts[category][col].setdefault(columnValue, 0)
                    counts[category][col][columnValue] += 1
				}
			}
			end
		end
        
        #
        # ok done counting. now compute probabilities
        #
        # first prior probabilities p(h)
        #
		classes.each{ |category, count|
            @prior[category] = count / total
		}
        #
        # now compute conditional probabilities p(h|D)
        #
		counts.each{ |category, columns|
				if (! @conditional.member?(category))
					@conditional[category] = {}
				end
	
			  columns.each{ |col, valueCounts|
			  	if (! @conditional.member?(category))
					@conditional[category] = {}
				end
				  valueCounts.each { |attrValue, count|
                      @conditional[category][col][attrValue] = (count / classes[category])
				}
			}
		}
        @tmp =  counts               
        
	end

           
    def testBucket(file, num)
        #Evaluate the classifier with data from the file
        # bucketPrefix-bucketNumber"""
        
		bucket = file + "-" + num.to_s.rjust(2, "0")
        lines = IO.readlines(bucket)
        totals = {}
        loc = 1
        lines.each{ |line|
            loc += 1
            data = line.strip().split('\t')
            vector = []
            classInColumn = -1
			Range.new(1, @format.length).each { |i|
                  if @format[i] == 'num'
                      vector.append(float(data[i]))
                  elsif @format[i] == 'attr'
                      vector.append(data[i])
                  elsif @format[i] == 'class'
                      classInColumn = i
				  end
			}
            theRealClass = data[classInColumn]
            classifiedAs = self.classify(vector)
			if (! totals.member?(theRealClass))
				totals[theRealClass] = {}
			end
			if (!totals[theRealClass].member?(classifiedAs))
				totals[theRealClass][classifiedAs] = 0
			end
            totals[theRealClass][classifiedAs] += 1
		}
        return totals

	end

    
    def classify(itemVector)
        results = []
		@prior.each { |category, prior|
            prob = prior
            col = 1
			itemVector.each{ |attrValue|
                if (!  @conditional[category][col].member?(attrValue))
                    # we did not find any instances of this attribute value
                    # occurring with this category so prob = 0
                    prob = 0
                else
                    prob = prob * @conditional[category][col][attrValue]
				end
                col += 1
			}
            results.push([prob, category])
		}
        # return the category with the highest probability
        return(results.max[1])
	end
 
end

def tenfold(bucketPrefix, dataFormat)
    results = {}
	(1...11).each { |i|
        c = Classifier.new(bucketPrefix, i, dataFormat)
        t = c.testBucket(bucketPrefix, i)
		t.each {|key, value|
			if (!results.member?(key))
				results[key] = {};
			end
			value.each { |ckey, cvalue|
				if (!results[key].member?(ckey))
					results[key][ckey] = 0
				end
                results[key][ckey] += cvalue
			}
		}
	}
                
    # now print results
    categories = results.keys().flatten()
    categories.sort()
    print(   "\n            Classified as: ")
    header =    "             "
    subheader = "               +"
	categories.each { |category|
        header += "% 10s   " % category
        subheader += "-------+"
	}
    print (header)
    print (subheader)
    total = 0.0
    correct = 0.0
	categories.each {|category|
        row = " %10s    |" % category 
		categories.each { |c2|
			if results[category].member?(c2)
                count = results[category][c2]
            else
                count = 0
			end
            row += " %5i |" % count
            total += count
            if c2 == category
                correct += count
			end
		}
        print(row)
	}
    print(subheader)
    print("\n%5.3f percent correct" %((correct * 100) / total))
    print("total of %i instances" % total)
end

#tenfold("house-votes/hv", "class\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr")
#c = Classifier("house-votes/hv", 0,
#                       "class\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr")

#c = Classifier("iHealth/i", 10,
#                       "attr\tattr\tattr\tattr\tclass")
#print(c.classify(['health', 'moderate', 'moderate', 'yes']))

c = Classifier.new("house-votes/hv", 5, "class\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr\tattr")
t = c.testBucket("house-votes/hv", 5)
print(t)
#c = Classifier.new("pimaSmall/pimaSmall", 1, "num\tnum num num num num num num class")

