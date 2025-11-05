
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id : myWindow
    visible: true
    color: Qt.rgba(0,0,0,0.8)
    width: 400
    height: _settingsId.implicitHeight
    title: "Raouf's API Athan"



    property bool log : true
    property color focusColor: "gold" //"#c0ec2b"
    property color bgColor: "#95cc2b" // "lightgreen"

    property string currentTime: Qt.formatTime(new Date(), "hh:mm:ss")

    // refresh time
    Timer {
            interval: 1000    // toutes les 1 seconde
            running: true
            repeat: true
            onTriggered: currentTime = Qt.formatTime(new Date(), "hh:mm:ss")
        }

    // getTodayDate()
    function getTodayDate(){
        let d = new Date(); // format : dd-mm-yyyy
        return String(d.getDate()) +"-"+ String(d.getMonth() + 1 ) +"-"+ d.getFullYear();
    }

    // Fonction pour appeler l'API
    function callApi(date, address, IdMethod) {
        var xhr = new XMLHttpRequest()


        //-------------------------------------------------------------------------------------------------------
        //  exmple with algeirs :   https://api.aladhan.com/v1/timingsByAddress/25-09-2015?address=algiers&method=19
        //  fixed part :            https://api.aladhan.com/v1/timingsByAddress/
        //  additional part :       {date}?adrress={adress}&method={IdMethod}
        //-------------------------------------------------------------------------------------------------------

        var querryDate = date ? date : getTodayDate()

        var querryIdMethod = IdMethod ? IdMethod : 19 // default : 19 = algeria
        var querryAdress = address ? address  : "Alger"

        var baseUrl = "https://api.aladhan.com/v1/timingsByAddress/"
        var querry = querryDate + "?address=" + querryAdress + "&method=" + querryIdMethod
        var url = baseUrl + querry

        // call API
        xhr.open("GET", url)

        // log url request
        if(myWindow.log === true)
            console.log("url request : " + url)

        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.DONE)
            {

                if(myWindow.log === true)
                {
                    console.log("------------Begin log--------------")
                    console.log("response : "+ xhr.responseText)
                    console.log("------------End log----------------")
                }


                if (xhr.status === 200)
                {
                    var response = JSON.parse(xhr.responseText)

                    _DateId.text = "Date : " + response.data.date.readable
                    _LocationId.text =  response.data.meta.timezone
                    _FajrId.text = "Fajr : "+ response.data.timings.Fajr
                    _SunriseId.text = "Sunrise : " + response.data.timings.Sunrise
                    _DhuhrId.text = "Dhuhr : "+ response.data.timings.Dhuhr
                    _AsrID.text = "Asr : "+ response.data.timings.Asr
                    _SunsetId.text = "Sunset : "+ response.data.timings.Sunset
                    _MaghribId.text = "Maghrib : "+ response.data.timings.Maghrib
                    _IshaId.text = "Isha : "+ response.data.timings.Isha
                    _ImsakId.text = "Imsak : "+ response.data.timings.Imsak
                    _MidnightId.text = "Midnight : "+ response.data.timings.Midnight
                    _LastthirdId.text = "LastThird : "+ response.data.timings.Lastthird
                }
                else
                {
                    apiTitle.text = "Erreur :" + xhr.status
                }
            }
        }
        xhr.send()

    }

    ColumnLayout{
        id : _settingsId
        width: parent.width
        height: parent.height
        spacing : 5

        RowLayout{

            height:  2*_InputAddressId.implicitHeight
            spacing : 10



            ColumnLayout{


                height: parent.height
                spacing : 10



                // input addresss
                Text {
                    text: "Input a valid adresse :"
                    font.pointSize: _SunriseId.font.pointSize + 2
                    font.bold: false
                    color: _SunriseId.color
                    Layout.alignment: Qt.AlignHCenter

                }

                Rectangle{
                    id : rect_inputAddress
                    Layout.fillWidth: true
                    height: _InputAddressId.implicitHeight

                    color: bgColor
                    border.color:   _InputAddressId.activeFocus ? focusColor : "green"
                    border.width: 2
                    radius: height / 2                    // rend la forme ovale



                    TextField {
                        id: _InputAddressId
                        anchors.fill: parent
                        font.pointSize: 10
                        width: parent.width
                        placeholderText: "Input adresse..."
                        padding : 10
                        horizontalAlignment: Text.AlignHCenter   // texte centré horizontalement
                        verticalAlignment: Text.AlignVCenter     // texte centré verticalement
                        background: null
                    }
                }


                // input date
                Text {
                    text: "Input a valid date (dd:mm:yyyy) :"
                    font.pointSize: _SunriseId.font.pointSize + 2
                    font.bold: false
                    color: _SunriseId.color
                    Layout.alignment: Qt.AlignHCenter

                }

                Rectangle{
                    id : rect_inputDate
                    Layout.fillWidth: true
                    height: _inputDateId.implicitHeight
                    color: bgColor
                    border.color:  _inputDateId.activeFocus ? focusColor : "green"
                    border.width: 2
                    radius: height / 2                    // rend la forme ovale


                    TextField {
                        id: _inputDateId
                        anchors.fill: parent
                        font.pointSize: 10
                        width: parent.width
                        placeholderText: "Input date..."
                        text: getTodayDate()

                        padding : 10
                        horizontalAlignment: Text.AlignHCenter   // texte centré horizontalement
                        verticalAlignment: Text.AlignVCenter     // texte centré verticalement
                        background: null
                    }
                }
                /*
                Rectangle{
                    visible : false
                    Layout.fillWidth: true
                    height: _inputMethodId.implicitHeight



                    TextField {
                        id: _inputMethodId
                        anchors.fill: parent
                        font.pointSize: 10
                        placeholderText: "Input method..."
                    }

                }

                */



            }


            Image{
                id: athanIcon

                Layout.preferredWidth: parent.height
                Layout.preferredHeight: parent.height - Layout.topMargin
                Layout.rightMargin: 10
                Layout.topMargin: 10


                source :"img/athan.png"

                fillMode: Image.PreserveAspectFit
                smooth: true
                antialiasing: true
                onStatusChanged: {
                    console.log("Image status:", status)
                    if (status === Image.Error)
                        console.warn("Erreur : impossible de charger", source)
                }

            }
        }

        Button {

            property string myAddress : "alger"
            property string myDate :  "today"
            property string myMethod : "19"

            text: "Get Athan times"
            onClicked:
            {
                myDate  = qsTr(_inputDateId.text)
                myAddress =  qsTr(_InputAddressId.text)
                myMethod =  "19"

                callApi(myDate , myAddress, myMethod) // 19 : agler

                _resultsId.visible = true
                myWindow.height = 550//_resultsId.implicitHeight + _settingsId.implicitHeight

                // Centrage
                myWindow.x = (Screen.width - myWindow.width) / 2
                myWindow.y = (Screen.height - myWindow.height) / 2
            }
            height: 30
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
        }

        Column {
            id : _resultsId
            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            visible : false

            Text {
                id: _LocationId
                text: "location :"
                font.bold: true
                font.pointSize: 10
                color: focusColor
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: _DateId
                text: "Date : "
                font.bold: true
                font.pointSize: 15
                color: "#66ccff"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Text {
                id: _currentTimeId
                text: currentTime
                font.bold: true
                font.pointSize: 20
                color: "white"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }




            Text {
                id: _FajrId
                text: "Fajr : "
                font.bold: true
                color: "gold"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: _SunriseId
                text: "Sunrise : "
                color: "white"
                font.bold: true
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Text{
                id : _DhuhrId
                text : "Dhuhr : "
                font.bold: true
                color: "gold"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                id: _AsrID
                text: "Asr :"
                font.bold: true
                color: "gold"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: _SunsetId
                text: "Sunset :"
                color: "white"
                font.bold: true
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter

            }


            Text {
                id: _MaghribId
                text: "Maghrib :"
                font.bold: true
                color: "gold"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Text{
                id : _IshaId
                text : "Isha :"
                font.bold: true
                color: "gold"
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: _ImsakId
                text: "Imsak : "
                color: "white"
                font.bold: true
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: _MidnightId
                text: "Midnight : "
                color: "white"
                font.bold: true
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Text {
                id: _LastthirdId
                text: "Lastthird : "
                color: "white"
                font.bold: true
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter

            }

        }
    }



}
