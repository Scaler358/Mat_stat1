#include "matstat.h"
#include "QDebug"

MatStat::MatStat(QObject *parent) : QObject(parent),vybirka(),yMax(-1),gen(){
    srand(static_cast<unsigned int>(std::time(nullptr)));
}
MatStat::~MatStat(){
    this->vybirka.clear();
}
QList<double> MatStat::toDouble(){
    QList<double> res;
    for(auto i:this->vybirka){
        res.append(i.toDouble());
    }
    return res;
}
QList<QVariant> MatStat::generate(const int from, const int to, const int size, const QString type) {
    QList<QVariant> res;
    if(type=="int"){
        for(int i=0;i<size;i++){
            res.append(this->gen.giveRandInt(from,to));
        }
    }
    else if(type=="double"){
        for(int i=0;i<size;i++){
            res.append(this->gen.giveRandDouble(from,to));
        }
    }
    else if(type=="doubleN"){
        for(int i=0;i<size;i++){
            res.append(this->gen.giveRandDoubleN(from,to));
        }
    }
    return res;
}
QList<QVariant> MatStat::sort(){
     QList<QVariant>temp=this->vybirka;
     std::sort(temp.begin(),temp.end());
     return temp;
}
const QVariant MatStat::med(){
    QList<QVariant> temp=this->sort();
    int ind=this->vybirka.length();
    if(ind%2==1)
        return temp[ind/2+1];
    else {
        return (temp[ind/2-1].toDouble()+temp[ind/2].toDouble())/2;
    }
}
const QVariant MatStat::mod(){
    QVariant res=QVariant();
    int cnt=-1;
    for (auto i:this->getStatRozp()) {
        if(i.toString().split(":")[1].toInt()>cnt){
            cnt=i.toString().split(":")[1].toInt();
            res=i.toString().split(":")[0];
        }
    }
    return res;
}
const QVariant MatStat::modN(){
    QVariant res=QVariant();
    int cnt=-1;
    for (auto i:this->getStatRozpN()) {
        if(i.toString().split(":")[1].toInt()>cnt){
            cnt=i.toString().split(":")[1].toInt();
            res=i.toString().split(':')[0];
        }
    }
    return res;
}
const QVariant MatStat::ser(){
    QList<double> temp=this->toDouble();
    return std::accumulate(temp.begin(),temp.end(),0.0)/static_cast<double>(temp.length());
}
const QVariant MatStat::rozm(){
    QList<QVariant> temp=this->sort();
    return temp.last().toDouble()-temp.first().toDouble();
}
const QVariant MatStat::dev(int n){
    QList<QVariant> temp=this->getStatRozp();
    double res=0.0;
    double ser=this->ser().toDouble();
    for(auto i:temp){
        res+=pow((i.toString().split(":")[0].toDouble()-ser),n)*i.toString().split(":")[1].toDouble();
    }
    return res;
}
QList <QVariant> MatStat::kvant(){
    QList<QVariant> res;
    int toSep=0;
    if(this->vybirka.length()%4==0)
        toSep=4;
    else if(this->vybirka.length()%8==0)
        toSep=8;
    else if(this->vybirka.length()%10==0)
        toSep=10;
    else
        return res;
    QList<QVariant> temp=this->sort();
    toSep=this->vybirka.length()/toSep;
    for(int i=toSep-1;i<temp.length()-1;i+=toSep){
        res.append(temp.at(i));
    }
    return res;
}
const QVariant MatStat::mom(int n){
    return this->dev(n).toDouble()/static_cast<double>(this->vybirka.length());
}
QVariant MatStat::getChar(){
    QString res="1. Центральні тенденції \n";
    QString kvant;
    QList<QVariant> kv=this->kvant();
    switch (kv.length()) {
    case 3:
        kvant="Квартиль";break;
    case 7:
        kvant="Октиль";break;
    case 9:
        kvant="Дециль";break;
    default:
        kvant="";break;
    }
    res=res+"Медіана : "+this->med().toString()+'\n';
    res=res+"Мода : "+this->mod().toString()+'\n';
    res=res+"Середнє : "+this->ser().toString()+'\n';
    res+="2. Характеристики розсіювання\n";
    res=res+"Розмах : "+this->rozm().toString()+'\n';
    res=res+"Девіація : "+this->dev().toString()+'\n';
    res=res+"Варіанса : "+QString::number(this->dev().toDouble()/static_cast<double>(this->vybirka.length()-1))+'\n';
    res=res+"Станд. розс. : "+QString::number(sqrt(this->dev().toDouble()/static_cast<double>(this->vybirka.length()-1)))+'\n';
    res=res+"Варіація : "+QString::number(sqrt(this->dev().toDouble()/static_cast<double>(this->vybirka.length()-1))/this->ser().toDouble())+'\n';
    res=res+"Дисперсія : "+QString::number(this->dev().toDouble()/static_cast<double>(this->vybirka.length()))+'\n';
    if(kvant!=""){
        int cnt=1;
        res+="3. Квантилі\n";
        for(auto i:kv){
            res=res+kvant+" "+QString::number(cnt++)+" : "+i.toString()+"\n";
        }
        res+="Інтер-квантильна широта : "+QString::number(kv.last().toDouble()-kv.first().toDouble())+'\n';
    }
    res+="4. Моменти\n";
    for(int i=2;i<5;i++)
        res=res+"Момент "+QString::number(i)+" : "+QString::number(this->mom(i).toDouble())+"\n";
    res+="Коефіціент асиметрії : "+QString::number(this->mom(3).toDouble()/pow(this->mom().toDouble(),2.0/3.0))+'\n';
    res+="Коефіціент ексцеса : "+QString::number(this->mom(4).toDouble()/pow(this->mom().toDouble(),2)-3)+'\n';
    return res;
}
QVariant MatStat::getCharZ(){
    QList<QVariant> temp;
    QList<QVariant> buffer=this->getStatRozpN();
    for(auto i:buffer){
        temp.append((i.toString().split(":")[0].split(";")[0].toDouble()+i.toString().split(":")[0].split(";")[0].toDouble())/2.0);
    }
    QVariant modN=this->modN();
    buffer=this->vybirka;
    this->vybirka=temp;
    QString res="1. Центральні тенденції \n";
    QString kvant;
    QList<QVariant> kv=this->kvant();
    switch (kv.length()) {
    case 3:
        kvant="Квартиль";break;
    case 7:
        kvant="Октиль";break;
    case 9:
        kvant="Дециль";break;
    default:
        kvant="";break;
    }
    res=res+"Медіана : "+this->med().toString()+'\n';
    this->vybirka=buffer;
    res=res+"Мода : "+modN.toString()+'\n';
    this->vybirka=temp;
    res=res+"Середнє : "+this->ser().toString()+'\n';
    res+="2. Характеристики розсіювання\n";
    res=res+"Розмах : "+this->rozm().toString()+'\n';
    res=res+"Девіація : "+this->dev().toString()+'\n';
    res=res+"Варіанса : "+QString::number(this->dev().toDouble()/static_cast<double>(this->vybirka.length()-1))+'\n';
    res=res+"Станд. розс. : "+QString::number(sqrt(this->dev().toDouble()/static_cast<double>(this->vybirka.length()-1)))+'\n';
    res=res+"Варіація : "+QString::number(sqrt(this->dev().toDouble()/static_cast<double>(this->vybirka.length()-1))/this->ser().toDouble())+'\n';
    res=res+"Дисперсія : "+QString::number(this->dev().toDouble()/static_cast<double>(this->vybirka.length()))+'\n';
    if(kvant!=""){
        int cnt=1;
        res+="3. Квантилі\n";
        for(auto i:kv){
            res=res+kvant+" "+QString::number(cnt++)+" : "+i.toString()+"\n";
        }
        res+="Інтер-квантильна широта : "+QString::number(kv.last().toDouble()-kv.first().toDouble())+'\n';
    }
    res+="4. Моменти\n";
    for(int i=2;i<5;i++)
        res=res+"Момент "+QString::number(i)+" : "+QString::number(this->mom(i).toDouble())+"\n";
    res+="Коефіціент асиметрії : "+QString::number(this->mom(3).toDouble()/pow(this->mom().toDouble(),2.0/3.0))+'\n';
    res+="Коефіціент ексцеса : "+QString::number(this->mom(4).toDouble()/pow(this->mom().toDouble(),2)-3)+'\n';
    this->vybirka=buffer;
    temp.clear();
    buffer.clear();
    return res;
}
QList<QVariant> MatStat::getStatRozp(){
    QList<QString> sortedVybToString;
    QList<QVariant> result;
    for(auto i:this->vybirka){
        sortedVybToString.append(i.toString());
    }
    int count=-1;
    int temp;
    for(auto i:sortedVybToString.toSet()){
        temp=sortedVybToString.count(i);
        if(temp>count)
            count=temp;
        result.append(QString(i+" : "+QString::number(temp)));
    }
    this->yMax=count;
    std::sort(result.begin(),result.end(),[](const QVariant a,const QVariant b){return a.toString().split(":")[0].toFloat()<b.toString().split(":")[0].toFloat();});
    return result;
}
QList<QVariant> MatStat::getStatRozpN(){
    QList<QString> sortedVybToString;
    QList<QVariant> result;
    int kilkIntervaliv=0;
    int count=-1;
    int cnt=0;
    int temp=0;
    while(this->vybirka.length()>=pow(2,kilkIntervaliv)){
        kilkIntervaliv++;
    }
    kilkIntervaliv-=1;
    for(auto i:this->vybirka){
        sortedVybToString.append(i.toString());
    }
    std::sort(sortedVybToString.begin(),sortedVybToString.end(),[](const QString a,const QString b){return a.toDouble()<b.toDouble();});
    double rozmah=sortedVybToString.last().toDouble()-sortedVybToString.first().toDouble();
    double dovzhInterval=rozmah/kilkIntervaliv;
    double currentMax=sortedVybToString.first().toDouble()+dovzhInterval;
    for(auto i : sortedVybToString){
        if(cnt!=kilkIntervaliv-1){
            if(i.toDouble()<currentMax)
                temp++;
            else {
                if(temp>count)
                    count=temp;
                result.append(QString(QString::number(currentMax-dovzhInterval)+" ; "+QString::number(currentMax)+":"+QString::number(temp)));
                temp=0;
                cnt++;
                currentMax+=dovzhInterval;
                temp++;
                }
        }
        else {
            if(i.toDouble()<sortedVybToString.last().toDouble()+1)
                temp++;
        }
    }
    result.append(QString(QString::number(currentMax-dovzhInterval)+" ; "+QString::number(sortedVybToString.last().toDouble())+":"+QString::number(temp)));
    this->yMax=count;
    return result;
}
int MatStat::getYMax(){
    return this->yMax;
}
QList<QVariant> MatStat::getEFR(){
    QList<QVariant> temp=this->getStatRozp();
    QList<QVariant> res;
    for(auto i:temp){
        res.append(i.toString().split(":")[0]+":"+QString::number(i.toString().split(":")[1].toDouble()/static_cast<double>(this->vybirka.length())));
    }
    return res;
}
QList<QVariant> MatStat::getEFR_N(){
    QList<QVariant> temp=this->getStatRozpN();
    QList<QVariant> res;
    for(auto i:temp){
        res.append(i.toString().split(":")[0]+":"+QString::number(i.toString().split(":")[1].toDouble()/static_cast<double>(this->vybirka.length())));
    }
    return res;
}
void MatStat::slotBuildVybirka(const int from, const int to, const int size, const QString type){
    this->vybirka.clear();
    QFuture<QList<QVariant>> fut=QtConcurrent::run(this,&MatStat::generate,from,to,size,type);
    fut.waitForFinished();
    this->vybirka=fut.result();
    emit signalComplete();
}
const QList<QVariant> MatStat::slotGetVybirka(){
    emit signalComplete();
    return this->vybirka;
}
const QList<QVariant> MatStat::slotGetSortedVybirka(){
    QFuture<QList<QVariant>> fut=QtConcurrent::run(this,&MatStat::sort);
    emit signalComplete();
    return  fut.result();
}
const QList<QVariant> MatStat::slotGetStatRozp(const QString type){
    QFuture<QList<QVariant>> fut;
    if(type!="doubleN")
        fut=QtConcurrent::run(this,&MatStat::getStatRozp);
    else
        fut=QtConcurrent::run(this,&MatStat::getStatRozpN);
    emit signalComplete();
    return fut.result();
}
const QString MatStat::slotGetChar(){
    QFuture<QVariant> fut=QtConcurrent::run(this,&MatStat::getChar);
    emit signalComplete();
    return fut.result().toString();
}
const QString MatStat::slotGetCharZ(){
    QFuture<QVariant> fut=QtConcurrent::run(this,&MatStat::getCharZ);
    emit signalComplete();
    return fut.result().toString();
}
const QList<QVariant> MatStat::slotGetEFR(const QString type){
    QFuture<QList<QVariant>> fut;
    if(type!="doubleN")
        fut=QtConcurrent::run(this,&MatStat::getEFR);
    else
        fut=QtConcurrent::run(this,&MatStat::getEFR_N);
    emit signalComplete();
    return fut.result();
}
