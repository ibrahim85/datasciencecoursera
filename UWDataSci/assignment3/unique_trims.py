import MapReduce
import sys

"""
Unique DNA Trims Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: DNA identifier
    # value: Trimmed value
    key = record[0]
    value = record[1][:-10]
    
    mr.emit_intermediate(value, "dummy")

def reducer(key, list_of_values):
    # key: Trimmed DNA
    #We are letting the hashing implicitly remove duplicates for us.

    mr.emit(key)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
