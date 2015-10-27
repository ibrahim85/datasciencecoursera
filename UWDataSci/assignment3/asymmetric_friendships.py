import MapReduce
import sys

"""
Asymmetric Friendship Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: sorted friend list
    # value: hasFriend
    key = ''.join(sorted(record))
    value= record
    mr.emit_intermediate(key,record)

def reducer(key, list_of_values):
    # key: friend pair
    # value: uni-directional instances
    if len(list_of_values)==1:
      mr.emit(tuple(list_of_values[0]))
      mr.emit(tuple(list_of_values[0][::-1]))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
