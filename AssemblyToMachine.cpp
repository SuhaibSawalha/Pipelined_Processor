#include <bits/stdc++.h>
using namespace std;

string reg (string r) {
  int x = stoi(r.substr(1));
  return bitset<3>(x).to_string();
}

void R_type (string func) {
  string r1, r2, r3;
  cin >> r1 >> r2 >> r3;
  cout << "0000" << reg(r1) << reg(r2) << reg(r3) << func << "\n";
}

void I_type (string opcode) {
  string r1, r2;
  int x = 0;
  cin >> r1 >> r2;
  if (opcode != "1000") {
    cin >> x;
  }
  else {
    swap(r1, r2);
  }
  cout << opcode << reg(r2) << reg(r1) << bitset<6>(x).to_string() << "\n";
}
    
int main () {

  #ifndef ONLINE_JUDGE
    freopen("Satoru", "r", stdin);
  #endif

  ios_base::sync_with_stdio(false);
  cin.tie(NULL);

  string code;
  while (cin >> code) {
    if (code == "AND") {
      R_type("000");
    }
    else if (code == "ADD") {
      R_type("001");
    }
    else if (code == "SUB") {
      R_type("010");
    }
    else if (code == "SLL") {
      R_type("011");
    }
    else if (code == "SRL") {
      R_type("100");
    }
    else if (code == "ANDI") {
      I_type("0010");
    }
    else if (code == "ADDI") {
      I_type("0011");
    }
    else if (code == "LW") {
      I_type("0100");
    }
    else if (code == "SW") {
      I_type("0101");
    }
    else if (code == "BEQ") {
      I_type("0110");
    }
    else if (code == "BNE") {
      I_type("0111");
    }
    else if (code == "FOR") {
      I_type("1000");
    }
    else if (code == "JMP") {
      int x;
      cin >> x;
      cout << "0001" << bitset<9>(x).to_string() << "000\n";
    }
    else if (code == "CALL") {
      int x;
      cin >> x;
      cout << "0001" << bitset<9>(x).to_string() << "001\n";    
    }
    else if (code == "RET") {
      cout << "0001" << bitset<9>(0).to_string() << "010\n";    
    }
    else {
      cout << "INVALID CODE" << endl;
      assert(false);
    }
  }


  return 0;
}



/*

ADDI R1 R0 6
SW R1 R0 0
ADDI R1 R0 14
SW R1 R0 1
ADDI R1 R0 23
SW R1 R0 2
ADDI R1 R0 2
SW R1 R0 3
ADDI R1 R0 5
SW R1 R0 4
ADDI R3 R0 4
ADDI R5 R0 12
LW R4 R2 0
ADDI R2 R2 1
FOR R5 R3
ADDI R7 R0 7
BEQ R6 R7 2
ADDI R6 R0 7
ADDI R3 R0 4
ADDI R2 R0 0
LW R4 R2 0
ADDI R2 R2 1
BNE R2 R3 -2 
CALL 25
JMP 27
ADDI R6 R0 1
RET
ADDI R6 R0 15


*/






/*


ADDI R1 R0 3
SW R1 R0 0
LW R2 R0 0
ADD R3 R1 R2
ADD R4 R1 R3
LW R5 R4 -9
ADD R6 R4 R5
ADD R7 R6 R6
SRL R7 R7 R1
SLL R6 R6 R1


*/