#ifndef RANDGEN_H
#define RANDGEN_H
#include <random>
#include <cmath>

class RandGen
{
public:
    RandGen();
    int giveRandInt(const int from,const int to) const;
    double giveRandDouble(const int from,const int to)const;
    double giveRandDoubleN(const int from,const int to)const;
};

#endif // RANDGEN_H
