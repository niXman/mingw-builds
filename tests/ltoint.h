class Int
{
public:
  Int(int i = 0);
  Int operator+(const Int& rhs);
  Int& operator=(int rhs);
  int value;
};
