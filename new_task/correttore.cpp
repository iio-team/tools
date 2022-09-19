#include <algorithm>
#include <cassert>
#include <cmath>
#include <fstream>
#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using namespace std;

enum result_t {
    UNEXPECTED, // correct output is incoherent
    EXCELLENT,  // better than optimal
    SUCCESS,    // exactly optimal
    PARTIAL,    // worse than optimal but coherent
    WRONG,      // correct output format, incorrect logic
    MALFORMED   // incorrect output format
};

const vector<string> MSG = {
    "Reference output is wrong",
    "Output is extraordinary",
    "translate:success",
    "translate:partial",
    "translate:wrong",
    "Output is malformed"
};

const vector<float> VAL = {-1, 1.1, 1.0, -1, 0.0, 0.0};

bool reading_corr = true;

void ex(float score, string message) {
  cout << score << endl;
  cerr << message << endl;
  exit(0);
}

void ex(float score) {
  assert(not reading_corr);
  ex(score, MSG[PARTIAL]);
}

void ex(result_t result, string extra = "") {
  assert(result != PARTIAL);
  assert(result != UNEXPECTED);
  if (reading_corr) {
    assert(result != EXCELLENT);
    assert(result != SUCCESS);
    result = UNEXPECTED;
  }
  ex(VAL[result], MSG[result] + (extra == "" ? "" : " (" + extra + ")"));
}

template <typename T> inline void read(ifstream &s, T &x) {
  if (!(s >> x))
    ex(MALFORMED);
}

template <typename T1, typename T2, typename... Ts>
inline void read(ifstream &s, T1 &x1, T2 &x2, Ts &...xs) {
  read(s, x1);
  read(s, x2, xs...);
}

template <typename T = int> inline T read(ifstream &s) {
  T x;
  read(s, x);
  return x;
}

inline void close(ifstream &s) {
  char c;
  while (s.get(c))
    if (!isspace(c))
      ex(MALFORMED);
}

inline void limit(int min, int val, int max) {
  if (val < min)
    ex(MALFORMED);
  if (val > max)
    ex(MALFORMED);
}

// copy-paste the C++ template variables here
int N;
vector<int> V;
// ------------------------------------------

// read output, check and get numeric value for scoring
long long read_output(ifstream &s) {
    // replace the output checking logic
    int C;
    read(s, C);
    limit(1, C, 100);
    if (C == 3)
        ex(WRONG);
    close(s);
    return C;
}

int main(int argc, char const *argv[]) {
  if (argc < 4) {
    cerr << "usage: ./checker <input> <correct> <user>" << endl;
    return 0;
  }
  ifstream cin(argv[1]);
  ifstream corr(argv[2]);
  ifstream user(argv[3]);

  // copy-paste the C++ template logic here
    cin >> N;
    V.resize(N);
    for (int i=0; i<N; i++)
        cin >> V[i];
  // --------------------------------------

  long long Scorr = read_output(corr);
  reading_corr = false;
  long long Suser = read_output(user);

  if (Suser > Scorr) {
    ex(EXCELLENT, string("Suser=") + to_string(Suser) + " Scorr=" + to_string(Scorr));
  }
  if (Suser == Scorr) ex(SUCCESS);

    // replace the scoring logic
  double factor = Suser * 1.0 / Scorr;
  ex(factor);
  return 0;
}
