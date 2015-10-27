import MapReduce
import sys

"""
Matrix Multiplication Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # matrix: matrix identifier
    # row: row index
    # col: column index
    # value: cell value

    #We are assuming multiplying a 5x5 matrix
    matrix, row, col, value=record[0],record[1],record[2],record[3]
    k=0
    if matrix=="a":
        for k in range(5):
          mr.emit_intermediate((row,k),["a",col,value])
    else:
        for i in range(5):
          mr.emit_intermediate((i,col),["b",row,value])

def reducer(key, list_of_values):
    # key: cell coordinates
    # value: list of occurrence counts
    i = key[0]
    j = key[1]
    a=[0]*5
    b=[0]*5
    for cell in list_of_values:
      matrix=cell[0]
      index= cell[1]
      value=cell[2]
      if matrix=="a":
        a[index]=value
      else:
        b[index]=value
    total = 0
    for n in range(len(a)):
      total+=a[n]*b[n]

    mr.emit((i, j, total))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
