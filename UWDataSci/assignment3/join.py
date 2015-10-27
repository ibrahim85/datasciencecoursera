import MapReduce
import sys

"""
Relational Join Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # tag: string identifier for table of origin
    # orderID: order identifier to join on
    # value: remaining tuple values
    orderID = record[1]
    mr.emit_intermediate(orderID, record)

def reducer(key, list_of_values):
    # key: orderID to join on
    # value: list of order and line item data
    for row in list_of_values:
        if row!=list_of_values[0]:
            mr.emit(list_of_values[0]+row)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
