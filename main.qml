import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import MatStatistic 1.0
import QtCharts 2.3

ApplicationWindow {
    id : mainwindow
    visible: true
    width: 400
    height: 800
    property int size: height>width?height:width
    property string type: "int"
    property string type_t: "int"
    onHeightChanged: size=height>width?height:width
    onWidthChanged: size=height>width?height:width
    title: qsTr("Індивідуальне завдання")
    Material.theme: Material.Light
    Material.accent: Material.Blue
    Material.elevation: 5
        Rectangle{
            id : rect_basics
            anchors.top: parent.top
            height: mainwindow.height*0.25
            width: parent.width
            Rectangle{
                id: rect_slider
                anchors.topMargin: 20
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.left: parent.left
                width : parent.width*0.5
                height: parent.height*0.75
                    Label{
                        id:label_range
                        text: qsTr("З / По ")
                        anchors.top: parent.top
                        width: parent.width
                        height: parent.height*0.3
                        font {
                            pixelSize:height/3
                        }
                    }
                        TextEdit{
                            id:text_edit_from
                            anchors.left: parent.left
                            anchors.top: label_range.bottom
                            text:Math.round(range_slider.first.value,1)
                            onTextChanged: range_slider.first.value=text_edit_from.text
                            width: parent.width/2
                            height: parent.height*0.3
                            clip: true
                            font {
                                pixelSize:height/3
                            }
                        }
                        TextEdit{
                            id:text_edit_to
                            anchors.top: label_range.bottom
                            anchors.right: parent.right
                            text:Math.round(range_slider.second.value,1)
                            onTextChanged: range_slider.second.value=parseInt(text_edit_to.text)
                            width: parent.width/2
                            height: parent.height*0.3
                            clip: true
                            font {
                                pixelSize:height/3
                            }
                        }
                    RangeSlider{
                        id: range_slider
                        anchors.left: parent.left
                        anchors.top: text_edit_from.bottom
                        width: parent.width
                        height: parent.height*0.3
                        from: 1
                        to: 1000
                        stepSize: 1
                        snapMode: "SnapAlways"
                        second.value: 100

                    }
            }
            Rectangle{
                id: rect_type
                anchors.topMargin: 20
                anchors.top: parent.top
                anchors.left: rect_slider.right
                width: parent.width*0.25
                height: parent.height*0.75
                Column{
                    anchors.fill: parent
                    Label{
                        text: qsTr("Дискр/Непер ")
                        width: parent.width
                        height: parent.height*0.3
                        font {
                            pixelSize:height/3
                        }
                    }
                    RadioButton{
                        id: but_dyskr
                        text:qsTr("Дискр")
                        width: parent.width
                        height: parent.height*0.3
                        checked: true
                        font {
                            pixelSize:height/3
                        }
                        onCheckedChanged: {
                            but_int.checkable=true;
                        }
                    }
                    RadioButton{
                        id: but_neper
                        text:qsTr("Непер")
                        width: parent.width
                        height: parent.height*0.3
                        font {
                            pixelSize:height/3
                        }
                        onCheckedChanged: {
                            but_float.checked=true;
                            but_int.checkable=false;
                        }
                    }
                }
            }
            Rectangle{
                id: rect_type_1
                anchors.topMargin: 20
                anchors.top: parent.top
                anchors.left: rect_type.right
                anchors.right: parent.right
                width: parent.width*0.25
                height: parent.height*0.75
                Column{
                    anchors.fill: parent
                    Label{
                        text: qsTr("Тип ")
                        width: parent.width
                        height: parent.height*0.3
                        font {
                            pixelSize:height/3
                        }
                    }
                    RadioButton{
                        id: but_int
                        text:qsTr("int")
                        width: parent.width
                        height: parent.height*0.3
                        checked: true
                        font {
                            pixelSize:height/3
                        }
                    }
                    RadioButton{
                        id: but_float
                        text:qsTr("float")
                        width: parent.width
                        height: parent.height*0.3
                        font {
                            pixelSize:height/3
                        }
                    }
                }
            }
            Rectangle{
                width: parent.width
                height: parent.height*0.25
                anchors.bottom: parent.bottom
                Label{
                    id: label_size
                    anchors.leftMargin: 10
                    text: qsTr("Розмір ")
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    height: parent.height
                    width: height*2
                    font {
                        pixelSize:height/3
                    }
                }
                TextEdit{
                    id: text_edit_size
                    anchors.bottom: parent.bottom
                    anchors.left: label_size.right
                    height: parent.height
                    width: height*2
                    text: "100"
                    font {
                        pixelSize:height/3
                    }
                }

                BusyIndicator{
                    id:busy
                    visible: false
                    anchors.rightMargin: 10
                    anchors.right: but_generate.left
                    anchors.bottom: parent.bottom
                    height: parent.height
                    width: height
                }
                Button{
                    id: but_generate
                    highlighted: true
                    anchors.topMargin: 20
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: parent.height
                    width: height*3
                    onClicked: {
                        busy.visible=true;
                        var type;
                        if(but_dyskr.checked){
                            if(but_int.checked)
                                type="int";
                            else
                                type="double";
                        }
                        else
                            type="doubleN";
                        mainwindow.type=type;
                        if(mainwindow.type=="doubleN")
                            type="doubleN"
                        else if(mainwindow.type=="double")
                            type=parseInt(text_edit_size.text)<11?"int":"doubleN";
                        else if(mainwindow.type=="int")
                            type=parseInt(text_edit_to.text)-parseInt(text_edit_from.text)+1<100?"int":"doubleN";
                        mainwindow.type_t=type;
                        mat_stat.slotBuildVybirka(range_slider.first.value,range_slider.second.value,text_edit_size.text,mainwindow.type);
                    }

                    text: qsTr("Згенерувати")
                }
            }
        }
        Rectangle{
            id: rect_buttons
            width: parent.width
            height: mainwindow.height*0.15
            anchors.top: rect_basics.bottom
            property int but_quant: 6
            Flow{
                anchors.fill: parent
                spacing: 10
                anchors.margins: 10
                Button{
                    id: but_vybirka
                    highlighted: true
                    enabled: false
                    height: width/2>100?100:width/2
                    width: parent.width/rect_buttons.but_quant-10>parent.height?parent.width/rect_buttons.but_quant-10:parent.height
                    text:qsTr("Вибірка")
                    onClicked: {
                        busy.visible=true;
                        rect_efr.visible=false;
                        res_bar.visible=false;
                        rect_charts.visible=false;
                        restext.text=""
                        restext.visible=true;
                        restext.text=mat_stat.slotGetVybirka().join("\t");
                        flick_.contentHeight=restext.contentHeight+20;
                    }
                }
                Button{
                    id: but_var_ryad
                    enabled: false
                    highlighted: true
                    height: width/2>100?100:width/2
                    width: parent.width/rect_buttons.but_quant-10>parent.height?parent.width/rect_buttons.but_quant-10:parent.height
                    text:qsTr("Вар ряд")
                    onClicked: {
                        busy.visible=true;
                        res_bar.visible=false;
                        rect_efr.visible=false;
                        rect_charts.visible=false;
                        restext.visible=true;
                        restext.text=""
                        restext.text=mat_stat.slotGetSortedVybirka().join("\t")
                        flick_.contentHeight=restext.contentHeight+20;
                    }
                }
                Button{
                    id: but_stat_rozp
                    enabled: false
                    highlighted: true
                    height: width/2>100?100:width/2
                    width: parent.width/rect_buttons.but_quant-10>parent.height?parent.width/rect_buttons.but_quant-10:parent.height
                    text:qsTr("Стат розп")
                    onClicked: {
                        busy.visible=true;
                        rect_charts.visible=false;
                        res_bar.visible=false;
                        rect_efr.visible=false;
                        restext.visible=true;
                        restext.text="";
                        var temp=mat_stat.slotGetStatRozp(mainwindow.type_t);
                        var tempstring="";
                        for(var i=0;i<temp.length;i++){
                            if(mainwindow.type_t!=="doubleN"){
                                tempstring="\n|| "+temp[i];
                            }
                            else{
                                if(i!==temp.length-1)
                                    tempstring=" \n|| [ "+temp[i].split(":")[0]+" ) : "+temp[i].split(":")[1];
                                else
                                {
                                    tempstring=" \n|| [ "+temp[i].split(":")[0]+" ] : "+temp[i].split(":")[1];
                                }
                            }
                            restext.text+=tempstring;
                        }
                        flick_.contentHeight=restext.contentHeight+20;
                    }
                }
                Button{
                    id: but_grafik
                    enabled: false
                    highlighted: true
                    height: width/2>100?100:width/2
                    width: parent.width/rect_buttons.but_quant-10>parent.height?parent.width/rect_buttons.but_quant-10:parent.height
                    text:qsTr("Графік")
                    onClicked: {
                        var temp=mat_stat.slotGetStatRozp(mainwindow.type);
                        restext.visible=false;
                        rect_efr.visible=false;
                        if(mainwindow.type!=="doubleN"){
                            flick_.contentHeight=mainwindow.height*1.2;
                            res_bar.visible=false;
                            line_series.clear();
                            line_series_p.clear();
                            for(var i =0;i<temp.length;i++){
                                line_series.append(temp[i].split(":")[0],temp[i].split(":")[1]);
                                line_series_p.append(temp[i].split(":")[0],temp[i].split(":")[1]);
                            }
                            axisY.max=mat_stat.yMax+1;
                            axisX.min=parseFloat(temp[0].split(":")[0]);
                            axisX.max=parseFloat(temp[temp.length-1].split(":")[0]);
                            axisY_p.max=mat_stat.yMax+1;
                            axisX_p.min=parseFloat(temp[0].split(":")[0]);
                            axisX_p.max=parseFloat(temp[temp.length-1].split(":")[0]);
                            rect_charts.visible=true;
                        }
                        else{
                            flick_.contentHeight=flick_.height;
                            rect_charts.visible=false;
                            barser.clear();
                            var arrCat=new Array;
                            var arrVal=new Array;
                            for(i in temp){
                                arrCat.push("["+temp[i].split(":")[0]+"]");
                                arrVal.push(parseInt(temp[i].split(":")[1]));
                            }
                            bar_ax.categories=arrCat;
                            axisYY.max=mat_stat.yMax+1;
                            barser.append("Вибірка",arrVal);
                            res_bar.visible=true;
                        }
                    }
                }
                Button{
                    id: but_efr
                    enabled: false
                    highlighted: true
                    height: width/2>100?100:width/2
                    width: parent.width/rect_buttons.but_quant-10>parent.height?parent.width/rect_buttons.but_quant-10:parent.height
                    text:qsTr("ЕФР*")
                    onClicked: {
                        busy.visible=true;
                        rect_charts.visible=false;
                        res_bar.visible=false;
                        restext.visible=false;
                        res_efr_text.text="";
                        var temp=mat_stat.slotGetEFR(mainwindow.type_t);
                        if(mainwindow.type_t!=="doubleN")
                            res_efr_text.text="F(x)* =  \n|| 0.00, x < "+temp[0].split(":")[0];
                        else
                            res_efr_text.text="F(x)* =  \n|| 0.00, x < "+temp[0].split(":")[0].split(";")[0];
                        var acc=0;
                        var tempstring;
                        for(var i =0;i<temp.length;i++){
                            acc+=parseFloat(temp[i].split(":")[1]);
                            if(mainwindow.type_t!=="doubleN"){
                                tempstring="\n|| "+acc.toPrecision(3)+", x <= "+temp[i].split(":")[0];
                            }
                            else
                            {
                                if(i!==temp.length-1)
                                    tempstring=" \n||  "+acc.toPrecision(3)+", x є ["+temp[i].split(":")[0]+" )";
                                else
                                    tempstring=" \n||  "+acc.toPrecision(3)+", x є ["+temp[i].split(":")[0]+" ]";
                            }
                            res_efr_text.text+=tempstring;
                        }
                        if(mainwindow.type_t!=="doubleN")
                            res_efr_text.text+=" \n||  1.00"+", x > "+temp[temp.length-1].split(":")[0];
                        else
                            res_efr_text.text+=" \n||  1.00"+", x > "+temp[temp.length-1].split(":")[0].split(";")[1];
                        temp=mat_stat.slotGetEFR("doubleN");
                        line_series_efr.clear();
                        acc=0;
                        line_series_efr.append(0,acc);
                        line_series_efr.append(parseFloat(temp[0].split(":")[0].split(";")[0]),acc);
                        for(i=0;i<temp.length;i++){
                            acc+=parseFloat(temp[i].split(":")[1]);
                            line_series_efr.append(parseFloat(temp[i].split(":")[0].split(";")[0]),acc);
                            line_series_efr.append(parseFloat(temp[i].split(":")[0].split(";")[1]),acc);
                        }
                        line_series_efr.append(parseFloat(range_slider.second.value),acc);
                        axisX_efr.min=parseInt(range_slider.first.value)-1;
                        axisX_efr.max=range_slider.second.value;
                        rect_efr.visible=true;
                        flick_.contentHeight=res_efr_text.contentHeight+20+flick_.width;

                    }
                }
                Button{
                    id: but_char
                    enabled: false
                    highlighted: true
                    height: width/2>100?100:width/2
                    width: parent.width/rect_buttons.but_quant-10>parent.height?parent.width/rect_buttons.but_quant-10:parent.height
                    text:qsTr("Числ хар")
                    onClicked: {
                        busy.visible=true;
                        rect_efr.visible=false;
                        rect_charts.visible=false;
                        res_bar.visible=false;
                        restext.visible=true;
                        restext.text="";
                        restext.text+=mat_stat.slotGetChar();
                        if(mainwindow.type==="doubleN"){
                            restext.text+="\nЗа серединами проміжків : \n\n"
                            restext.text+=mat_stat.slotGetCharZ();
                        }
                        flick_.contentHeight=restext.contentHeight+20;
                    }
                }
            }
        }
        Flickable{
          id:flick_
          state: "State0"
          width: parent.width
          height:parent.height*0.6
          anchors.top: rect_buttons.bottom
          contentHeight:height
          contentWidth: width
          clip: true
          Rectangle{
              anchors.fill: parent;
            Text{
                id:restext
                anchors.fill: parent
                anchors.margins: 10
                visible: false
                font{
                    pixelSize:mainwindow.size/50
                }
                wrapMode: Text.Wrap
          }
            Rectangle{
                id:rect_efr
                anchors.fill: parent
                anchors.margins: 10
                visible: false
                Text{
                    id:res_efr_text
                    width: parent.width
                    height: contentHeight
                    font{
                        pixelSize:mainwindow.size/50
                    }
                    wrapMode: Text.Wrap
                }
                ChartView{
                    id:res_efr_chart
                    anchors.top: res_efr_text.bottom
                    anchors.bottom: parent.bottom
                    width: parent.width
                    title: "Графік ЕФР"
                    antialiasing: true
                    ValueAxis{
                        id:axisX_efr
                        tickCount: res_efr_chart.width/100
                    }
                    ValueAxis{
                        id:axisY_efr
                        min: 0
                        max: 1
                    }

                    LineSeries{
                        id:line_series_efr
                        axisX: axisX_efr
                        axisY: axisY_efr
                    }
                }
            }
            Rectangle{
                id:rect_charts
                anchors.fill: parent
                visible: false
                    ChartView{
                        id:chart_1
                        anchors.top: parent.top
                        width: parent.width
                        height: parent.height/2
                        title: "Графік вибірки"
                        antialiasing: true
                        ValueAxis{
                            id:axisX
                            tickCount: chart_1.width/100
                        }
                        ValueAxis{
                            id:axisY
                            min: 0
                        }

                        LineSeries{
                            id:line_series
                            axisX: axisX
                            axisY: axisY
                        }
                    }
                    ChartView{
                        id:chart_2
                        anchors.top: chart_1.bottom
                        width: parent.width
                        height: parent.height/2
                        title: "Графік вибірки (полігон)"
                        antialiasing: true
                        ValueAxis{
                            id:axisX_p
                            tickCount: chart_2.width/100
                        }
                        ValueAxis{
                            id:axisY_p
                            min: 0
                        }

                        AreaSeries{
                            id:area_series
                            axisX: axisX_p
                            axisY: axisY_p
                            upperSeries:LineSeries{
                                id:line_series_p
                            }
                        }
                    }
            }
            ChartView{
                id:res_bar
                visible: false
                anchors.fill:parent
                title: "Графік вибірки"
                antialiasing: true
                ValueAxis{
                    id:axisYY
                    min: 0
                }

                BarSeries{
                    id:barser
                    axisX: BarCategoryAxis{id:bar_ax}
                    axisY: axisYY
                }
            }
        }
        }
        MatStat{
            id: mat_stat
            onSignalComplete: {
                busy.visible=false;
                if(but_vybirka.enabled==false)
                {
                    but_vybirka.enabled=true;
                    but_var_ryad.enabled=true;
                    but_stat_rozp.enabled=true;
                    but_grafik.enabled=true;
                    but_efr.enabled=true;
                    but_char.enabled=true;
                }
                }
            }
        }

