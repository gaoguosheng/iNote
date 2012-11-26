<%@ page import="com.ggs.comm.Config" %>
<%@ page import="com.ggs.util.DateUtil" %>
<%@page language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isCheckLogin" value="1"></c:set>
<html>
<head>
<title><%=Config.SOFT_NAME%> - 工作进程</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<%@include file="inc.jsp"%>
<script>
    /* --------- SICON GANTT CHART -----------------------------------------------------------
     * AUTHOR		: Dathq - ICT Service Engineering Jsc, - dathq@ise.com.vn
     * LICENSE		: Free
     * DESCRIPTION	: Create a new task item with these info
     *		- from: start date (format: mm/dd/dddd)
     *		- to: deadline of task (format: mm/dd/dddd)
     *		- task: name of the task, what has to be solved (not includes ')
     *		- resource: who have to solve this task (not includes ')
     *		- progress: how is it going? (format: integer value from 0 to 100, not includes %)
     *----------------------------------------------------------------------------------------*/
    function Task(from, to, task, resource, progress)
    {
        var _from = new Date();
        var _to = new Date();
        var _task = task;
        var _resource = resource;
        var _progress = progress;
        var dvArr = from.split('-');
        _from.setFullYear(parseInt(dvArr[0], 10),parseInt(dvArr[1], 10)-1, parseInt(dvArr[2], 10) );
        dvArr = to.split('-');
        _to.setFullYear(parseInt(dvArr[0], 10),parseInt(dvArr[1], 10)-1, parseInt(dvArr[2], 10));

        this.getFrom = function(){ return _from};
        this.getTo = function(){ return _to};
        this.getTask = function(){ return _task};
        this.getResource = function(){ return _resource};
        this.getProgress = function(){ return _progress};
    }

    function Gantt(gDiv)
    {
        var _GanttDiv = gDiv;
        var _taskList = new Array();
        this.AddTaskDetail = function(value)
        {
            _taskList.push(value);

        }
        this.Draw = function()
        {
            var _offSet = 0;
            var _dateDiff = 0;
            var _currentDate = new Date();
            var _maxDate = new Date();
            var _minDate = new Date();
            var _dTemp = new Date();
            var _firstRowStr = "<table id='myTable' border=1 style='border-collapse:collapse'><tr><th rowspan='2' width='250px' style='width:200px;'><div class='GTaskTitle' style='width:200px;'>工作进程</div></th>";
            var _thirdRow = "";
            var _gStr = "";
            var _colSpan = 0;
            var counter = 0;

            _currentDate.setFullYear(_currentDate.getFullYear(), _currentDate.getMonth(), _currentDate.getDate());
            if(_taskList.length > 0)
            {
                _maxDate.setFullYear(_taskList[0].getTo().getFullYear(), _taskList[0].getTo().getMonth(), _taskList[0].getTo().getDate());
                _minDate.setFullYear(_taskList[0].getFrom().getFullYear(), _taskList[0].getFrom().getMonth(), _taskList[0].getFrom().getDate());
                for(i = 0; i < _taskList.length; i++)
                {
                    if(Date.parse(_taskList[i].getFrom()) < Date.parse(_minDate))
                        _minDate.setFullYear(_taskList[i].getFrom().getFullYear(), _taskList[i].getFrom().getMonth(), _taskList[i].getFrom().getDate());
                    if(Date.parse(_taskList[i].getTo()) > Date.parse(_maxDate))
                        _maxDate.setFullYear(_taskList[i].getTo().getFullYear(), _taskList[i].getTo().getMonth(), _taskList[i].getTo().getDate());
                }

                //---- Fix _maxDate value for better displaying-----
                // Add at least 5 days

                if(_maxDate.getMonth() == 11) //December
                {
                    if(_maxDate.getDay() + 5 > getDaysInMonth(_maxDate.getMonth() + 1, _maxDate.getFullYear()))
                        _maxDate.setFullYear(_maxDate.getFullYear() + 1, 1, 5); //The fifth day of next month will be used
                    else
                        _maxDate.setFullYear(_maxDate.getFullYear(), _maxDate.getMonth(), _maxDate.getDate() + 5); //The fifth day of next month will be used
                }
                else
                {
                    if(_maxDate.getDay() + 5 > getDaysInMonth(_maxDate.getMonth() + 1, _maxDate.getFullYear()))
                        _maxDate.setFullYear(_maxDate.getFullYear(), _maxDate.getMonth() + 1, 5); //The fifth day of next month will be used
                    else
                        _maxDate.setFullYear(_maxDate.getFullYear(), _maxDate.getMonth(), _maxDate.getDate() + 5); //The fifth day of next month will be used
                }

                //--------------------------------------------------

                _gStr = "";
                _gStr += "</tr><tr>";
                _thirdRow = "<tr><td>&nbsp;</td>";
                _dTemp.setFullYear(_minDate.getFullYear(), _minDate.getMonth(), _minDate.getDate());
                while(Date.parse(_dTemp) <= Date.parse(_maxDate))
                {
                    if(_dTemp.getDay() % 6 == 0) //Weekend
                    {
                        _gStr += "<td class='GWeekend'><div style='width:24px;'>" + _dTemp.getDate() + "</div></td>";
                        if(Date.parse(_dTemp) == Date.parse(_currentDate))
                            _thirdRow += "<td id='GC_" + (counter++) + "' class='GToDay' style='height:" + (_taskList.length * 21) + "'>&nbsp;</td>";
                        else
                            _thirdRow += "<td id='GC_" + (counter++) + "' class='GWeekend' style='height:" + (_taskList.length * 21) + "'>&nbsp;</td>";
                    }
                    else
                    {
                        _gStr += "<td class='GDay'><div style='width:24px;'>" + _dTemp.getDate() + "</div></td>";
                        if(Date.parse(_dTemp) == Date.parse(_currentDate))
                            _thirdRow += "<td id='GC_" + (counter++) + "' class='GToDay' style='height:" + (_taskList.length * 21) + "'>&nbsp;</td>";
                        else
                            _thirdRow += "<td id='GC_" + (counter++) + "' class='GDay'>&nbsp;</td>";
                    }
                    if(_dTemp.getDate() < getDaysInMonth(_dTemp.getMonth() + 1, _dTemp.getFullYear()))
                    {
                        if(Date.parse(_dTemp) == Date.parse(_maxDate))
                        {
                            _firstRowStr += "<td class='GMonth' colspan='" + (_colSpan + 1) + "'>T_" +_dTemp.getFullYear()+ "年" + (_dTemp.getMonth() + 1)  + "月</td>";
                        }
                        _dTemp.setDate(_dTemp.getDate() + 1);
                        _colSpan++;
                    }
                    else
                    {
                        _firstRowStr += "<td class='GMonth' colspan='" + (_colSpan + 1) + "'>T_" +_dTemp.getFullYear()+ "年" +  (_dTemp.getMonth() + 1) + "月</td>";
                        _colSpan = 0;
                        if(_dTemp.getMonth() == 11) //December
                        {
                            _dTemp.setFullYear(_dTemp.getFullYear() + 1, 0, 1);
                        }
                        else
                        {
                            _dTemp.setFullYear(_dTemp.getFullYear(), _dTemp.getMonth() + 1, 1);
                        }
                    }
                }
                _thirdRow += "</tr>";
                _gStr += "</tr>" + _thirdRow;
                _gStr += "</table>";
                _gStr = _firstRowStr + _gStr;
                for(i = 0; i < _taskList.length; i++)
                {
                    _offSet = (Date.parse(_taskList[i].getFrom()) - Date.parse(_minDate)) / (24 * 60 * 60 * 1000);
                    _dateDiff = (Date.parse(_taskList[i].getTo()) - Date.parse(_taskList[i].getFrom())) / (24 * 60 * 60 * 1000) + 1;
                    _gStr += "<div style='position:absolute; top:" + (20 * (i + 2)) + "; left:" + (_offSet * 27 + 204) + "; width:" + (27 * _dateDiff - 1 + 100) + "'><div title='' class='GTask' style='float:left; width:" + (27 * _dateDiff - 1) + "px;'>" + getProgressDiv(_taskList[i].getProgress()) + "</div><div style='float:left; padding-left:3'>" + _taskList[i].getResource() + "</div></div>";
                    _gStr += "<div style='position:absolute; top:" + (20 * (i + 2) + 1) + "; left:5px'>" + _taskList[i].getTask() + "</div>";
                }
                _GanttDiv.innerHTML = _gStr;
            }
        }
    }

    function getProgressDiv(progress)
    {
        return "<div class='GProgress' style='width:" + progress + "%; overflow:hidden'></div>"
    }
    // GET NUMBER OF DAYS IN MONTH
    function getDaysInMonth(month, year)
    {

        var days;
        switch(month)
        {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
                days = 31;
                break;
            case 4:
            case 6:
            case 9:
            case 11:
                days = 30;
                break;
            case 2:
                if (((year% 4)==0) && ((year% 100)!=0) || ((year% 400)==0))
                    days = 29;
                else
                    days = 28;
                break;
        }
        return (days);
    }
    /*----- END OF MY CODE FOR Gantt CHART GENERATOR -----*/
</script>
<style>
        /*----- SICON GANTT CHART STYLE CLASSES --------------------------
       * DESCRIPTION	: Theses class is required for SIcon Gantt Chart
       * NOTE			: Should change the color, the text style only
       *----------------------------------------------------------------*/
    .Gantt
    {
        font-family:tahoma, arial, verdana;
        font-size:11px;
    }

    .GTaskTitle
    {
        font-family:tahoma, arial, verdana;
        font-size:11px;
        font-weight:bold;
    }

    .GMonth
    {
        padding-left:5px;
        font-family:tahoma, arial, verdana;
        font-size:11px;
        font-weight:bold;
    }

    .GToday
    {
        background-color: #FDFDE0;
    }

    .GWeekend
    {
        font-family:tahoma, arial, verdana;
        font-size:11px;
        background-color:#F5F5F5;
        text-align:center;
    }

    .GDay
    {
        font-family:tahoma, arial, verdana;
        font-size:11px;
        text-align:center;
    }

    .GTask
    {
        border-top:1px solid #CACACA;
        border-bottom:1px solid #CACACA;
        height:14px;
        background-color:#e0ffff;
    }

    .GProgress
    {
        background-color:#87cefa;
        height:5px;
        overflow: hidden;
        margin-top:5px;
    }
</style>


<script type="text/javascript">

    /**
     * 生成甘特图
     * */
    function f_getGantt(){
        
        var g = new Gantt(document.all.GanttChart);
        var json = $GGS.getJSON("progress?task=getProgessList",vData);
        for(var i=0;i<json.length;i++){
            var img="<img src='images/denied.png' title='未开始，"+json[i].pc+"%'>";
            if(json[i].pc==100){
                img="<img src='images/ok.png' title='已完成，"+json[i].pc+"%'>";
            }else if(json[i].pc>0 && json[i].pc<100){
                img="<img src='images/shortkey.png' title='进行中，"+json[i].pc+"%'>";
            }
            g.AddTaskDetail(new Task(json[i].startdate,json[i].enddate, '<a href="#" onclick="f_openGanttDialog('+json[i].id+');">'+img+" "+json[i].cname+"</a>",json[i].realname , json[i].pc));
        }
        g.Draw();

		//固定首行
        //f_fixGrid();

    }

    /**
     * 获取用户
     * */

    function f_getUsers(){
        var sel =document.all.userid;
        var users = $GGS.getJSON("main?task=getUsers",{});
        for(var i=0;i<users.length;i++){
            sel.options[sel.length]=new Option(users[i].realname,users[i].id);
        }
    }

    /**
     * 打开编辑窗口
     * */
    function f_openGanttDialog(proid){
        $("#ganttWindow").css("display","block");
        if(proid!=undefined){
            var json =$GGS.getJSON("progress?task=getProgressById",{proid:proid});
            $("#proid").val(json.id);
            $("#cname").val(json.cname);
            $("#userid").val(json.userid);
            $("#startdate").val(json.startdate);
            $("#enddate").val(json.enddate);
            $("#pc").val(json.pc);
            $("#prjid").val(json.prjid);
            $("#memo").val(json.memo);
            $("#realdate").val(json.realdate);
        }else{
            $("#cname").val("新进程");
            $("#userid").attr("selectedIndex","0");
            $("#startdate").val("<%=DateUtil.getDate("yyyy-MM-dd")%>");
            $("#enddate").val("<%=DateUtil.getDate("yyyy-MM-dd")%>");
            $("#pc").attr("selectedIndex","0");
            $("#proid").val("");
            $("#prjid").attr("selectedIndex","0");
            $("#memo").val("");
            $("#realdate").val("");
        }

        $("#ganttWindow").window(
                {
                    title:'编辑进程',
                    width:700,
                    height:550,
                    modal:true,
                    minimizable:false,
                    maximizable:false,
                    collapsible:false
                }
        );
    }
    /**
     * 关闭窗口
     * */
    function f_closeGanttWindow(){
        $("#ganttWindow").window("close");
    }

    /**
     * 保存进程
     * */
    function f_saveProgress(){
       if($("#cname").val()==""){
           f_alertError("进程名称不能为空！");
           return false;
       }
        if($("#pc").val()<"100" && $("#realdate").val()!=""){
            f_alertError("进度小于100时，不能填写完成日期！");
            return false;
        }

        if($("#pc").val()=="100" && $("#realdate").val()==""){
            f_alertError("进度为100时，完成日期不能为空！");
            return false;
        }


        $GGS.ajax("progress?task=saveProgress",{
            proid:$("#proid").val(),
            cname:$("#cname").val(),
            userid:$("#userid").val(),
            startdate:$("#startdate").val(),
            enddate:$("#enddate").val(),
            pc:$("#pc").val(),
            memo:$("#memo").val(),
            prjid:$("#prjid").val(),
            realdate:$("#realdate").val()
        });
        f_getGantt();
        f_closeGanttWindow();
    }

    /**
     * 获取日期列表
     * */
    function f_getDateList(){
        var json = $GGS.getJSON("progress?task=getProgressDateList",{});
        var div="";
        for(var i=0;i<json.length;i++){
            div+="<div onclick='f_clearVData();vData.startdate=\""+json[i].yearmonth+"\";f_getGantt();'>"+json[i].yearmonth+"</div>";
        }
        $("#dateListDiv").html(div);
    }

    /**
     * 获取项目列表
     * */
    function f_getProjectList(){
        var sel =document.all.prjid;
        var json = $GGS.getJSON("progress?task=getProjectList",{});
        var div="";
        for(var i=0;i<json.length;i++){
            sel.options[sel.length]=new Option(json[i].cname,json[i].id);
            div+="<div onclick='f_clearVData();vData.prjid="+json[i].id+";f_getGantt();'>"+json[i].cname+"</div>";
        }
        $("#projectListDiv").html(div);
    }


    /**
     * 清空参数
     * */
    function f_clearVData(){
        vData.startdate="";
        vData.prjid="";
        vData.userid=undefined;
    }

	/**
	固定首行
	*/
	function f_fixGrid(){
		//固定首行
		$("#headerDiv").css("display","none");
		$("#headerDiv").html("");
        $("#headerDiv").html($("#myTable").clone());
        var tables = document.getElementsByTagName("table");
        tables[1].deleteRow(2);
        $("#GanttChart").scroll(function(){      
			$("#headerDiv").css("display","block");
			$("#headerDiv").attr("scrollLeft",$("#GanttChart").attr("scrollLeft"));
            if ($("#GanttChart").attr("scrollTop")<=36){				
                $("#GanttChart").attr("scrollTop",36);
            }
        });        
		
		$("#GanttChart").attr("scrollTop",0);
        $("#headerDiv").css("display","none");
		
	}

    /**
     * 删除进程
     * */
    function f_delProgress(){
        $.messager.confirm('提示', '是否确定删除此任务?', function(r){
            if (r){
                $GGS.ajax("progress?task=delProgress",{proid:$("#proid").val()});
                f_getGantt();
                f_closeGanttWindow();
            }
        });

    }

    /**
     * 我的进程
     * */
    function f_getMyProgress(){
        f_clearVData();
        vData.userid="${sessionScope.adminModel.userid}";
        f_getGantt();
    }

    /**
     * 全部进程
     * */
    function f_getAllProgress(){
        f_clearVData();
        f_getGantt();
    }

    var vData = new Object();
    /**
     * 初始化
     * */
    $(function(){
        vData.startdate="<%=DateUtil.getDate("yyyy-MM")%>";
        $("#okBtn").click(function(){f_saveProgress();});
        $("#closeBtn").click(function(){f_closeGanttWindow();});
        $("#delBtn").click(function(){f_delProgress();});
        //生成甘特图
        $("#GanttChart").css("height",screen.availHeight-320);

        f_getGantt();
        f_getUsers();


    }) ;
</script>
</head>

<body>
    <%@include file="top.jsp"%>
    <div>
        <a href='gantt_list.jsp' class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true">切换到列表模式</a>
        <a  href="#" onclick="f_getAllProgress();" class="easyui-linkbutton" data-options="plain:true" >全部进程</a>
        <c:if test="${sessionScope.adminModel!=null}">
            <a  href="#" onclick="f_getMyProgress();" class="easyui-linkbutton" data-options="plain:true" >我的进程</a>
        </c:if>
        <a  href="#" class="easyui-menubutton" data-options="menu:'#dateListDiv'" >按周期显示</a>
        <a  href="#" class="easyui-menubutton" data-options="menu:'#projectListDiv'" >按项目显示</a>
    </div>
    <div id="headerDiv" style="overflow: hidden;">
    </div>
	<div style="position:relative;overflow: auto;" class="Gantt" id="GanttChart"></div>
    <%@include file="foot.jsp"%>
<div id="ganttWindow" style="display: none;">
    <input type="hidden" id="proid">
    <table width="100%" align="center" border="0" cellpadding="5" class="normalFont">
        <tr>
            <td align="right" valign="top">所属项目</td>
            <td><select id="prjid" style="width: 200px;"></select></td>
        </tr>
        <tr>
        <td align="right" valign="top">进程名称</td>
        <td><input type="text" id="cname" style="width: 250px;"></td>
        </tr>
        <tr>
            <td align="right" valign="top">负责人</td>
            <td>
                <select id="userid" style="width: 120px;"></select>
            </td>
        </tr>
        <tr>
            <td align="right" valign="top">计划起始日期</td>
            <td><input type="text" id="startdate"  class="Wdate" size="10" onClick="WdatePicker()" readonly="readonly" ></td>
        </tr>
        <tr>
            <td align="right" valign="top">计划结束日期</td>
            <td><input type="text" id="enddate"  class="Wdate" size="10" onClick="WdatePicker()" readonly="readonly" ></td>
        </tr>
        <tr>
            <td align="right" valign="top">完成百份比</td>
            <td>
               <select id="pc">
                   <c:forEach var="i" begin="0" end="100" step="10">
                        <option value="${i}">${i}%</option>
                   </c:forEach>
               </select>
            </td>
        </tr>
        <tr>
            <td align="right" valign="top">实际完成日期</td>
            <td><input type="text" id="realdate"  class="Wdate" size="10" onClick="WdatePicker()" readonly="readonly" ></td>
        </tr>
        <tr>
            <td align="right" valign="top">备注：</td>
            <td><textarea rows="8" cols="60" id="memo"></textarea></td>
        </tr>
    </table>
</div>
    <div id="dateListDiv" class="normalFont" style="width: 120px;"></div>
    <div id="projectListDiv" class="normalFont" style="width: 200px;"></div>
    <script type="text/javascript">
        f_getDateList();
        f_getProjectList();
    </script>
</body>
</html>