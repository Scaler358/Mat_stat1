#ifndef MATSTAT_H
#define MATSTAT_H

#include <QObject>
#include <QList>
#include <map>
#include <randgen.h>
#include <QtConcurrent/QtConcurrent>
#include <algorithm>

class MatStat : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int yMax READ getYMax)
private:
    QList<QVariant> vybirka;
    int yMax;
    RandGen gen;
public:
    explicit MatStat(QObject *parent = nullptr);
    ~MatStat();
    QList<QVariant> generate(const int from, const int to, const int size, const QString type);
    QList<QVariant> sort();
    QList<double> toDouble();
    int getYMax();
    QList<QVariant> getStatRozp();
    QList<QVariant> getStatRozpN();
    QList<QVariant> getEFR();
    QList<QVariant> getEFR_N();
    const QVariant med();
    const QVariant mod();
    const QVariant modN();
    const QVariant ser();
    const QVariant rozm();
    const QVariant dev(int n=2);
    QList<QVariant> kvant();
    const QVariant mom(int n=2);
    QVariant getChar();
    QVariant getCharZ();
signals:
    void signalComplete();
public slots:
    void slotBuildVybirka(const int from, const int to, const int size, const QString type);
    const QList<QVariant> slotGetVybirka();
    const QList<QVariant> slotGetSortedVybirka();
    const QList<QVariant> slotGetStatRozp(const QString type);
    const QString slotGetChar();
    const QString slotGetCharZ();
    const QList<QVariant> slotGetEFR(const QString type);
};

#endif // MATSTAT_H
