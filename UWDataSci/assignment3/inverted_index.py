import MapReduce
import sys

"""
Inverted Index Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # docID: document identifier
    # value: document contents
    docID = record[0]
    value = record[1]
    words = value.split()
    seenBefore = {}
    for w in words:
      if not (w in seenBefore):
        mr.emit_intermediate(w, docID)
        seenBefore[w]=True


def reducer(key, list_of_values):
    # key: word
    # value: list of document identifiers
    mr.emit((key, list_of_values))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
