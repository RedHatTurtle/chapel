/*
 *  Check correctness of search functions
 */

use Search; use Sort only relativeComparator, keyComparator;

proc main() {

  var result: (bool, int);

  const strideD = {10..40 by 10},
        revStrideD = {10..40 by -10};

  // Sorted arrays
  const    A = [-4, -1, 2, 3],
        absA = [-1, 2, 3, -4],
        revA = [ 3, 2, -1, -4],
     revAbsA = [ -4, 3, 2, -1],
        strA = ['Brad', 'anthony', 'ben', 'david'],
    strideA : [strideD] int = [-4, -1, 2, 3],
    revStrideA : [revStrideD] int = [-4, -1, 2, 3];  // neg-stride revStrideA[0]=3 etc.

  // Comparators
  const absKey = new AbsKeyCmp(),
        absComp = new AbsCompCmp();


  // search
  result = search(A, 2);
  checkSearch(result, (true, 2), A, 'search');

  // linearSearch
  result = linearSearch(A, 2);
  checkSearch(result, (true, 2), A, 'linearSearch');

  // binarySearch
  result = binarySearch(A, 2);
  checkSearch(result, (true, 2), A, 'binarySearch');

  // eltType = string
  result = search(strA, 'ben');
  checkSearch(result, (true, 2), strA, 'search');

  /* Strided Arrays */
  result = linearSearch(strideA, 2);
  checkSearch(result, (true, 30), strideA, 'linearSearch');

  result = binarySearch(strideA, 2);
  checkSearch(result, (true, 30), strideA, 'binarySearch');

  result = linearSearch(revStrideA, 2);
  checkSearch(result, (true, 20), revStrideA, 'linearSearch');

  result = binarySearch(revStrideA, 2);
  checkSearch(result, (true, 20), revStrideA, 'binarySearch');

  /* Comparators */

  result = search(revA, 2, comparator=new reverseComparator(), sorted=true);
  checkSearch(result, (true, 1), revA, 'search');

  result = search(absA, 2, comparator=absKey, sorted=true);
  checkSearch(result, (true, 1), absA, 'search');

  result = search(absA, 2, comparator=absComp, sorted=true);
  checkSearch(result, (true, 1), absA, 'search');

  /* Not Found */

  result = linearSearch(strideA, 5);
  checkSearch(result, (false, strideD.highBound+strideD.stride), strideA, 'linearSearch');

  result = binarySearch(strideA, 5);
  checkSearch(result, (false, strideD.highBound+strideD.stride), strideA, 'binarySearch');

  result = linearSearch(revStrideA, 5);
  checkSearch(result, (false, revStrideD.highBound+abs(revStrideD.stride)), revStrideA, 'linearSearch');

  result = binarySearch(revStrideA, 5);
  checkSearch(result, (false, revStrideD.highBound+abs(revStrideD.stride)), revStrideA, 'binarySearch');

  result = search(A, 5, sorted=true);
  checkSearch(result, (false, A.domain.highBound+1), A, 'search');

  result = search(A, -5, sorted=true);
  checkSearch(result, (false, A.domain.lowBound), A, 'search');

  result = search(A, 0, sorted=true);
  checkSearch(result, (false, 2), A, 'search');

}


/* Checks array and resets values -- any output results in failure */
proc checkSearch(result, expected, arr, searchProc:string,
                 cmp = new defaultComparator()) {
  if result != expected {
    writeln(searchProc, '() function failed');
    writeln('eltType:    ', arr.eltType:string);
    writeln('idxType:    ', arr.domain.idxType:string);
    writeln('dimensions: ', arr.domain.dims());
    writeln('comparator: ', cmp.name());
    writeln('domain:');
    writeln(arr.domain);
    writeln('array:');
    writeln(arr);
    writeln('Incorrect result: ', result);
    writeln('Expected result:  ', expected);
  }
}



/* Enables more useful error messages */
proc defaultComparator.name() { return 'defaultComparator';}
proc reverseComparator.name() { return 'reverseComparator';}


/* Key Sort by absolute value */
record AbsKeyCmp: keyComparator {
  proc key(a) { return abs(a); }
  proc name() { return 'AbsKeyCmp'; }
}


/* Compare Sort by absolute value */
record AbsCompCmp: relativeComparator {
  proc compare(a, b) { return abs(a) - abs(b); }
  proc name() { return 'AbsCompCmp'; }
}

// unused
/* Key method should take priority over compare method */
record AbsKeyCompCmp {
  proc key(a) { return abs(a); }
  proc compare(a, b) { return a - b; }
  proc name() { return 'AbsKeyCompCmp'; }
}

// unused
/* Key method can return a non-numerical/string type, such as tuple */
record TupleCmp {
  proc key(a) { return (a, a); }
  proc name() { return 'TupleCmp'; }
}

