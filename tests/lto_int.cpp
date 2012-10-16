#include "lto_int.h"

Int::Int(int i)
{
  value = i;
}

Int Int::operator+(const Int& rhs)
{
  return Int(value + rhs.value);
}

Int& Int::operator=(int rhs)
{
  value = rhs;
  return *this;
}
