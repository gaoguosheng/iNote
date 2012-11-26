<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-9-29
  Time: 下午3:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="topSelected" value="6"></c:set>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>个人所得税计算方法</title>
    <%@include file="inc.jsp"%>

</head>

<body>
<%@include file="top.jsp"%>

<script language=javascript>
//工资、薪金所得 OK
function calcTax1(income){
    var tax;
    var diff=(income-2000);
    if (diff<=0) {tax=0;}
    if (diff>0&&diff<=500) {tax=diff*0.05;}
    if (diff>500&&diff<=2000) {tax=diff*0.1-25;}
    if (diff>2000&&diff<=5000) {tax=diff*0.15-125;}
    if (diff>5000&&diff<=20000) {tax=diff*0.2-375;}
    if (diff>20000&&diff<=40000) {tax=diff*0.25-1375;}
    if (diff>40000&&diff<=60000) {tax=diff*0.30-3375;}
    if (diff>60000&&diff<=80000) {tax=diff*0.35-6375;}
    if (diff>80000&&diff<=100000) {tax=diff*0.4-10375;}
    if (diff>100000&&diff>100000) {tax=diff*0.45-15375;}
    return tax;
}
function calcTaxnew(income){
    var tax;
    var diff=(income-3500);
    if (diff<=0) {tax=0;}
    if (diff>0&&diff<=1500) {tax=diff*0.03;}
    if (diff>1500&&diff<=4500) {tax=diff*0.1-105;}
    if (diff>4500&&diff<=9000) {tax=diff*0.20-555;}
    if (diff>9000&&diff<=35000) {tax=diff*0.25-1005;}
    if (diff>35000&&diff<=55000) {tax=diff*0.30-2755;}
    if (diff>55000&&diff<=80000) {tax=diff*0.35-5505;}
    if (diff>80000&&diff>80000) {tax=diff*0.45-13505;}
    return tax;
}

//个体工商户的生产、经营所得
function calcTax2(income){
    return 0
}


//对企事业单位的承包经营、承租经营所得
function calcTax3(income){
    return 0
}


//劳务报酬所得 OK
function calcTax4(income){

    var tax;
    var a;	//taxable amount 应税所得;
    if (income<=800){return 0;}

    if (income<=4000){tax=(income-800)*0.2}
    else{
        a=income * 0.8
        if(a<=20000){tax=a*0.2}
        if(a>20000 && a<=50000){tax=a*0.3-2000}
        if(a>50000){tax=a*0.4-7000}
    }

    return tax;

}



//稿酬所得 OK
function calcTax5(income){

    if (income<=800){return 0;}//少于800不用缴

    if (income<=4000)//定额扣除800，税率20%，减征30%
    {

        return ((income-800)*0.2*(1-0.3))
    }
    else//定率扣除20%，税率20%，减征30%
    {
        return (income * (1-0.2) * 0.2 * (1-0.3));
    }
}




//特许权使用费所得 OK
function calcTax6(income){

    if (income<=800){return 0;}//少于800不用缴

    if (income<=4000)//定额扣除800，税率20%
    {

        return ((income-800)*0.2);
    }
    else//定率扣除20%，税率20%
    {
        return (income * (1-0.2) * 0.2);
    }
}




//利息、股息、红利所得 OK
function calcTax7(income){
    return (income * 0.2);
}


//财产租赁所得
function calcTax8(income){
    if (income<=800){return 0;}//少于800不用缴

    var rate=0.2;//税率20%【对个人出租房屋取得的所得暂减按10%的税率征收个人所得税】
    if (document.getElementById("radioEx8_a").checked){rate=0.1}

    if (income<=4000)//定额扣除800
    {

        return ((income-800)*rate);
    }
    else//定率扣除20%
    {
        return (income * (1-0.2) * rate);
    }

}



//财产转让所得
function calcTax9(income){

    return (income*0.2);

}


//偶然所得 OK
function calcTax10(income){
    if (income<=10000){return 0}else{ return(income*0.2)}
}


//



function calcTax(num){

    var objIncome=document.getElementById("txtIncome"+num);
    var objTax=document.getElementById("txtTax"+num);

    if (objIncome.value=="" | isNaN(objIncome.value)){
        objIncome.focus();
        objIncome.select();
        alert("请填正确写收入金额！");
        return;
    }

    var income=objIncome.value;

    switch (num){
        case 1:
            objTax.value=1*calcTax1(income).toFixed(2)*1;
            break;


        case 2:
            objTax.value=calcTax2(income).toFixed(2)*1;
            break;

        case 3:
            objTax.value=calcTax3(income).toFixed(2)*1;
            break;

        case 4:
            objTax.value=calcTax4(income).toFixed(2)*1;
            break;

        case 5:
            objTax.value=calcTax5(income).toFixed(2)*1;
            break;

        case 6:
            objTax.value=calcTax6(income).toFixed(2)*1;
            break;

        case 7:
            objTax.value=calcTax7(income).toFixed(2)*1;
            break;

        case 8:
            objTax.value=calcTax8(income).toFixed(2)*1;
            break;

        case 9:
            objTax.value=calcTax9(income).toFixed(2)*1;
            break;

        case 10:
            objTax.value=calcTax10(income).toFixed(2)*1;
            break;

        case 11:
            document.form1.textfield4.value=spe(srSum);
            break;

    }

}




function new_taxCalc(){
    var incomeType=parseFloat(document.getElementById("selIncomeType").value);
    var objIncome=document.getElementById("txtIncome");
    if (objIncome.value=="" | isNaN(objIncome.value)){
        objIncome.focus();
        objIncome.select();
        alert("请填正确写收入金额！");
        return;
    }

    var income=parseFloat(objIncome.value);
    var objTax=document.getElementById("txtTax");
    switch (incomeType){
        case 1:

            var obj=document.getElementById("txtEx1_a");
            if (obj.value==""){obj.value="0"}
            if (isNaN(obj.value)){
                obj.focus();
                obj.select();
                alert("请填正确写社保、公积金金额！");
                return;
            }


            income=income-parseFloat(obj.value);
            objTax.value=calcTax1(income).toFixed(2)*1;
            document.getElementById("txtTax").value=calcTaxnew(income).toFixed(2)*1;
            break;

        case 2:
            objTax.value=calcTax2(income).toFixed(2)*1;
            break;

        case 3:
            objTax.value=calcTax3(income).toFixed(2)*1;
            break;

        case 4:
            objTax.value=calcTax4(income).toFixed(2)*1;
            break;

        case 5:
            objTax.value=calcTax5(income).toFixed(2)*1;
            break;

        case 6:
            objTax.value=calcTax6(income).toFixed(2)*1;
            break;

        case 7:
            objTax.value=calcTax7(income).toFixed(2)*1;
            break;

        case 8:
            objTax.value=calcTax8(income).toFixed(2)*1;
            break;

        case 9:
            var obj=document.getElementById("txtEx9_a");
            if (obj.value==""){obj.value="0"}
            if (isNaN(obj.value)){
                obj.focus();
                obj.select();
                alert("请填正确写财产原值金额！");
                return;
            }
            income=income-parseFloat(obj.value);

            obj=document.getElementById("txtEx9_b");
            if (obj.value==""){obj.value="0"}
            if (isNaN(obj.value)){
                obj.focus();
                obj.select();
                alert("请填正确写合理手续费！");
                return;
            }

            income=income-parseFloat(obj.value);

            objTax.value=calcTax9(income).toFixed(2)*1;
            break;

        case 10:
            objTax.value=calcTax10(income).toFixed(2)*1;
            break;

        case 11:
            document.form1.textfield4.value=spe(srSum);
            break;

    }
    if (objTax.value<0){objTax.value=0}
}


function changeIncomeType(){


    document.getElementById("divEx1").style.display="none";
    document.getElementById("divEx8").style.display="none";
    document.getElementById("divEx9").style.display="none";

    var selIncomeType=document.getElementById("selIncomeType");

//var incomeType=selIncomeType.options[selIncomeType.selectedIndex].value;
    var incomeType=parseFloat(selIncomeType.value);
    switch (incomeType){
        case 1:
            document.getElementById("divEx1").style.display="";
            break;

        case 8:
            document.getElementById("divEx8").style.display="";
            break;

        case 9:
            document.getElementById("divEx9").style.display="";
            break;
    }

    document.getElementById("divDesc1").className="descBlock";
    document.getElementById("divDesc2").className="descBlock";
    document.getElementById("divDesc3").className="descBlock";
    document.getElementById("divDesc4").className="descBlock";
    document.getElementById("divDesc5").className="descBlock";
    document.getElementById("divDesc6").className="descBlock";
    document.getElementById("divDesc7").className="descBlock";
    document.getElementById("divDesc8").className="descBlock";
    document.getElementById("divDesc9").className="descBlock";
    document.getElementById("divDesc10").className="descBlock";


    document.getElementById("divDesc"+incomeType).className="descBlock_on";




}
</script>


<table class="normalFont" width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#77ADFF"  style="bforder:#5fa7f9 solid 5px;" align="center">
<tr>
    <td align="center" bgcolor="#F1F5FA">个人所得税计算器</td>
</tr>
<tr>
    <td bgcolor="#f5fbff"><table width="100%" border="0" cellspacing="0" cellpadding="3">
        <tr>
            <td width="179" align="right">收入类型：</td>
            <td><select id="selIncomeType" name="selIncomeType" onchange="changeIncomeType()">
                <option value="1" selected="selected">工资、薪金所得 </option>
                <option value="4">劳务报酬所得 </option>
                <option value="5">稿酬所得 </option>
                <option value="6">特许权使用所得 </option>
                <option value="7">利息、股息、红利所得 </option>
                <option value="8">财产租赁所得 </option>
                <option value="9">财产转让所得 </option>
                <option value="10">偶然所得（如：中奖、中彩）</option>
            </select></td>
        </tr>
        <tr>
            <td width="179" align="right">收入总额（应发工资）：</td>
            <td><input name="txtIncome" type="text" id="txtIncome" size="20" />
                (元)</td>
        </tr>
    </table>
        <div id="divEx1">
            <table width="100%" border="0" cellpadding="3" cellspacing="0">
                <tr>
                    <td width="179" align="right">允许扣除部分（应扣合计）：</td>
                    <td><input name="txtEx1_a" type="text" id="txtEx1_a" size="20" />
                        (元) [如：三费一金等]</td>
                </tr>
            </table>
        </div>
        <div id="divEx8" style="display:none;">
            <table width="100%" border="0" cellpadding="3" cellspacing="0">
                <tr>
                    <td width="179" align="right">&nbsp;</td>
                    <td><input type="radio" value="1" name="radioEx8" id="radioEx8_a" checked="checked" />
                        个人房屋出租
                        <input type="radio" name="radioEx8" id="radioEx8_b" value="2" />
                        其他财产租赁</td>
                </tr>
            </table>
        </div>
        <div id="divEx9" style="display:none;">
            <table width="100%" border="0" cellpadding="3" cellspacing="0">
                <tr>
                    <td width="179" align="right">财产原值：</td>
                    <td><input name="txtEx9a" type="text" id="txtEx9_a" size="20" />
                        (元)</td>
                </tr>
                <tr>
                    <td width="179" align="right">合理交易费用：</td>
                    <td><input name="txtEx9b" type="text" id="txtEx9_b" size="20" />
                        (元)</td>
                </tr>
            </table>
        </div></td>
</tr>
<tr>
    <td bgcolor="#f5fbff"><table width="100%" border="0" cellpadding="3" cellspacing="0">
        <tr>
            <td width="179" align="right">&nbsp;</td>
            <td><input type="submit" name="Submit" value=" 计 算 " onclick="new_taxCalc()" /></td>
        </tr>
        <tr>
            <td width="179" align="right">应缴税额（代缴个税）：</td>
            <td><input name="tax" type="text" id="txtTax" size="20" />
                <input name="tax" type="hidden" id="txtTaxnew" size="20" />
                (元) </td>
        </tr>
        <tr>
            <td align="right">&nbsp;</td>
            <td><font color="red">(2011个人所得税法修正案3500起征点，9月1日起实施)</font></td>
        </tr>
    </table></td>
</tr>

</table>
<div align="center"><a  href="#" class="normalFont" onclick="tbdesc.style.display='';return false;" style="font-weight:bold;color:#0000E1;">点击查看详细说明>>></a></div>
<!-- desc begin-->
<table width="98%" border="0" id="tbdesc" style="display: none;" class="normalFont">
<tr>
<td><div class="descBlock_on" id="divDesc1">
    <div class="descTitle">工资薪金所得个人所得税计算方法</div>
    <div class="descContent"> 　　工资、薪金所得是指个人因任职或受雇而取得的工资、薪金、奖金、年终加薪、劳动分红、津贴、补贴以及与任职、受雇有关的其它所得。<br />
        工资薪金，以每月收入额减除费用扣除标准后的余额为应纳税所得额（从2011年9月1日起，起征点为3500元）。适用七级超额累进税率（3%至45%）计缴个人所得税。<br />
        三费一金是指社保费、医保费、养老费和住房公积金<br />
        <strong>计算公式是：</strong><br />
        <strong>工资、薪金所得个人所得税应纳税额=应纳税所得额&times;适用税率-速算扣除数 </strong>
        <table border="1" bordercolor="#999999" cellspacing="0" height="264" width="545">
            <tbody>
            <tr>
                <td width="53" height="39" align="center">级数</td>
                <td width="228" align="center">含税级距</td>
                <td width="216" align="center">不含税级距</td>
                <td width="48" align="center" valign="middle"><p align="center">税率<br />
                    （％）</p></td>
                <td width="60" align="center">速算<br />
                    扣除数</td>
            </tr>
            <tr>
                <td align="center">1</td>
                <td>不超过1500元的</td>
                <td>不超过1455元的</td>
                <td align="center">3</td>
                <td align="center">0</td>
            </tr>
            <tr>
                <td align="center">2</td>
                <td>超过1500元至4500元的部分</td>
                <td>超过1455元至4155元的部分</td>
                <td align="center">10</td>
                <td align="center">105</td>
            </tr>
            <tr>
                <td align="center">3</td>
                <td>超过4500元至9000元的部分</td>
                <td>超过4155元至7755元的部分</td>
                <td align="center">20</td>
                <td align="center">555</td>
            </tr>
            <tr>
                <td align="center">4</td>
                <td>超过9000元至35000元的部分</td>
                <td>超过7755元至27255元的部分</td>
                <td align="center">25</td>
                <td align="center">1005</td>
            </tr>
            <tr>
                <td align="center">5</td>
                <td>超过35000元至55000元的部分</td>
                <td>超过27255元至41255元的部分</td>
                <td align="center">30</td>
                <td align="center">2755</td>
            </tr>
            <tr>
                <td align="center">6</td>
                <td>超过55000元至80000元的部分</td>
                <td>超过41255元至57505元的部分</td>
                <td align="center">35</td>
                <td align="center">5505</td>
            </tr>
            <tr>
                <td align="center">7</td>
                <td>超过80000元的部分</td>
                <td>超过57505元的部分</td>
                <td align="center">45</td>
                <td align="center">13505</td>
            </tr>
            </tbody>
        </table>
        <p> 　　注：①表中所列含税级距、不含税级距，均为按照税法规定减除有关费用后的所得额。②含税级距适用于由纳税人负担税款的工资、薪金所得；不含税级距适用于由他人（单位）代付税款的工资、薪金所得。<br />
            例：王某当月取得工资收入9400元，当月个人承担住房公积金、基本养老保险金、医疗保险金、失业保险金共计1000元，费用扣除额为3500元，则  王某当月应纳税所得额=9400-1000-3500=4900元。应纳个人所得税税额=4900&times;20%-555=425元。</p>
    </div>
</div>
<div class="descBlock" id="divDesc2">
    <div class="descTitle"> 个体工商户的生产、经营所得计税规定 </div>
    <div class="descContent"> &nbsp;&nbsp;&nbsp;&nbsp;个体工商户的生产、经营所得是指：（1）个体工商户从事工业、手工业、建筑业、交通运输业、商业、饮食业、服务业、修理业以及其他行业生产、经营取得的所得；（2）个人经政府有关部门批准，取得执照，从事办学、医疗、咨询以及其他有偿服务活动取得的所得；（3）其他个人从事个体工商业生产、经营取得的所得；（4）上述个体工商户和个人取得的与生产、经营有关的各项应税所得；（5）依照《中华人民共和国个人独资企业法》和《中华人民共和国合伙企业法》登记成立的个人独资企业、合伙企业的投资者，依照《中华人民共和国私营企业暂行条例》登记成立的独资、合伙性质的私营企业的投资者，依照《中华人民共和国律师法》登记成立的合伙制律师事务所的投资者、经政府有关部门依照法律法规批准成立的负无限责任和无限连带责任的其他个人独资、个人合伙性质的机构或组织的投资者，所取得的生产经营所得，参照个体工商户的生产经营所得项目纳税。<br />
        个体工商户的生产、经营所得，以每一纳税年度的收入总额，减除成本、费用以及损失后的余额，为应纳税所得额。成本、费用，是指纳税义务人从事生产、经营所发生的各项直接支出和分配计入成本的间接费用以及销售费用、管理费用、财务费用；所说的损失，是指纳税义务人在生产、经营过程中发生的各项营业外支出。<br />
        从事生产、经营的纳税义务人未提供完整、准确的纳税资料，不能正确计算应纳税所得额的，由主管税务机关核定其应纳税所得额。<br />
        个体工商户的生产、经营所得，适用5％至35％的超额累进税率。<br />
        应纳税额 = 应纳税所得额 &times; 适用税率 - 速算扣除数。<br />
        <strong>　　 个人所得税税率表（个体工商户的生产、经营所得和对企事业单位的承包经营、承租经营所得适用）</strong><br />
        <table width="545" border="1" cellpadding="0" cellspacing="0" bordercolor="#999999">
            <tr>
                <td width="43"><p align="center">级数 </p></td>
                <td width="140"><p align="center">含税级距 </p></td>
                <td width="140"><p align="center">不含税级距 </p></td>
                <td width="49"><p align="center">税率(%) </p></td>
                <td width="63"><p align="center">速算扣除数 </p></td>
                <td width="175" align="center">说明</td>
            </tr>
            <tr>
                <td width="43"><p align="center">1</p></td>
                <td width="140"><p align="center">不超过5,000元的 </p></td>
                <td width="140"><p align="center">不超过4750元的 </p></td>
                <td width="49"><p align="center">5</p></td>
                <td width="63"><p align="center">0</p></td>
                <td width="175" rowspan="5"><p align="left"> 1、表中所列含税级距与不含税级距，均为按照税法规定减除有关成本（费用、损失）后的所得额。2、含税级距适用于个体工商户的生产、经营所得和对企事业单位的承包经营承租经营所得；不含税级距适用于由他人(单位)代付税款的承包经营、承租经营所得。 </p></td>
            </tr>
            <tr>
                <td width="43"><p align="center">2</p></td>
                <td width="140"><p align="center">超过5,000元到10,000元的部分 </p></td>
                <td width="140"><p align="center">超过4750元至9250元的部分 </p></td>
                <td width="49"><p align="center">10</p></td>
                <td width="63"><p align="center">250</p></td>
            </tr>
            <tr>
                <td width="43"><p align="center">3</p></td>
                <td width="140"><p align="center">超过10,000元至30,000元的部分 </p></td>
                <td width="140"><p align="center">超过9250元至25250元的部分 </p></td>
                <td width="49"><p align="center">20</p></td>
                <td width="63"><p align="center">1250</p></td>
            </tr>
            <tr>
                <td width="43"><p align="center">4</p></td>
                <td width="140"><p align="center">超过30,000元至50,000元的部分 </p></td>
                <td width="140"><p align="center">超过25250元至39250元的部分 </p></td>
                <td width="49"><p align="center">30</p></td>
                <td width="63"><p align="center">4250</p></td>
            </tr>
            <tr>
                <td width="43"><p align="center">5</p></td>
                <td width="140"><p align="center">超过50,000元的部分 </p></td>
                <td width="140"><p align="center">超过39250元的部分 </p></td>
                <td width="49"><p align="center">35</p></td>
                <td width="63"><p align="center">6750</p></td>
            </tr>
        </table>
        <br />
    </div>
</div>
<div class="descBlock" id="divDesc3">
    <div class="descTitle"> 对企事业单位的
        承包经营、承租经营所得计税规定 </div>
    <div class="descContent">&nbsp;&nbsp;&nbsp;&nbsp;企事业单位的承包经营、承租经营所得指个人承包经营、承租经营以及转包、转租取得的所得，包括个人按月或者按次取得的工资、薪金性质的所得。<br />
        企业实行个人承包、承租经营后，如果工商登记仍为企业的，不管其分配方式如何，均应先按照企业所得税的有关规定缴纳企业所得税。承包经营、承租经营者按照承包、承租经营合同（协议）规定取得的所得，依照个人所得税法的有关规定缴纳个人所得税，具体为：<br />
        A. 承包、承租人对企业经营成果不拥有所有权，仅是按合同（协议）规定取得一定所得的，其所得按工资、薪金所得项目征税，适用5％一45％的九级超额累进税率。<br />
        B. 承包、承租人按合同（协议）的规定只向发包、出租方交纳一定费用后，企业经营成果归其所有的，承包、承租人取得的所得，按对企事业单位的承包经营、承租经营所得项目，适用5％一35％的五级超额累进税率征税。<br />
        （2）企业实行个人承包、承租经营后，如工商登记改变为个体工商户的，应依照个体工商户的生产、经营所得项目计征个人所得税，不再征收企业所得税。<br />
        （3）企业实行承包经营、承租经营后，不能提供完整、准确的纳税资料、正确计算应纳税所得额的，由主管税务机关核定其应纳税所得额，并依据《中华人民共和国税收征收管理法》的有关规定，自行确定征收方式。（国税发［1994］ 179号）<br />
        对企事业单位的承包经营、承租经营所得，适用5％至35％的超额累进税率。计算方法为：<br />
        应纳税额 = 应纳税所得额 &times; 适用税率 - 速算扣除数。</div>
</div>
<div class="descBlock" id="divDesc4">
    <div class="descTitle">劳务报酬所得计税规定</div>
    <div class="descContent">&nbsp;&nbsp;&nbsp;&nbsp;劳务报酬所得指个人从事设计、装潢、安装、制图、化验、测试、医疗、法律、会计、咨询、讲学、新闻、广播、翻译、审稿、书画、雕刻、影视、录音、录像、演出、表演、广告、展览、技术服务、介绍服务、经纪服务、代办服务以及其他劳务取得的所得。个人担任董事职务所取得的董事费收入，按劳务报酬所得项目纳税。<br />
        劳务报酬所得以个人每次取得的收入，定额或定率减除规定费用后的余额为应纳税所得额。每次收入不超过4000元的，定额减除费用800元；每次收入在4000以上的，定率减除20%的费用。劳务报酬所得适用20%的比例税率；对于纳税人每次劳务报酬所得的应纳税所得额超过20000元至50000元的部分，适用30%的税率；超过50000元的部分，适用40%的税率 <br />
        注：实质上为超额累进税率，判断加成征税的依据是应纳税所得额而非收入额）<br />
        劳务报酬所得个人所得税应纳税额=应纳税所得额&times;适用税率-速算扣除数 <br />
        <table width="545" height="88" border="1" cellspacing="0" bordercolor="#999999">
            <tr>
                <td width="45" height="32"><div align="center">级数</div></td>
                <td width="217"><div align="center">含税所得</div></td>
                <td width="235"><div align="center">不含税收入额</div></td>
                <td width="46"><div align="center">税率<br />
                    （％）</div></td>
                <td width="52"><div align="center">速算<br />
                    扣除数</div></td>
            </tr>
            <tr>
                <td height="17"><div align="center">1</div></td>
                <td>不超过20000元的</td>
                <td>21000元以下的部分</td>
                <td><div align="center">20</div></td>
                <td><div align="center">0</div></td>
            </tr>
            <tr>
                <td height="17"><div align="center">2</div></td>
                <td>超过20000元至50000元的部分</td>
                <td>超过21000元至49500元的部分</td>
                <td><div align="center">30</div></td>
                <td><div align="center">2000</div></td>
            </tr>
            <tr>
                <td height="20"><div align="center">3</div></td>
                <td>超过50000元的部分</td>
                <td>超过49500元的部分</td>
                <td><div align="center">40</div></td>
                <td><div align="center">7000</div></td>
            </tr>
        </table>

        获取劳务报酬所得的纳税义务人从其收入中支付给中介人和相关人员的报酬，在定率扣除20%的费用后，一律不再扣除。对中介人和相关人员取得的上述报酬，应分别计征个人所得税（国税函[1996]602号） <br />
    </div>
</div>
<div class="descBlock" id="divDesc5">
    <div class="descTitle">稿酬所得计税规定</div>
    <div class="descContent"> &nbsp;&nbsp;&nbsp;&nbsp;稿酬所得指个人因其作品以图书、报刊形式出版、发表而取得的所得。作者去世后，财产继承人取得的遗作稿酬所得也应纳税。<br />
        稿酬所得以个人每次出版、发表作品取得的收入为一次，定额或定率减除规定费用后的余额为应纳税所得额。每次收入不超过4000元的，定额减除费用800元；每次收入在4000以上的，定率减除20%的费用。稿酬所得适用比例税率，税率为20%，并按应纳税额减征30%。 <br />
        个人所得税应纳税额 = 应纳税所得额 &times; 适用税率。实际缴纳税额=应纳税额&times;（1-30%）。 <br />
        任职、受雇于报刊、杂志等单位的记者、编辑等专业人员，因在本单位的报刊、杂志上发表作品取得的所得，属于因任职、受雇而取得的所得，应与其当月工资收入合并，按&ldquo;工资、薪金所得&rdquo;项目征收个人所得税。除上述专业人员以外，其他人员在本单位的报刊、杂志上发表作品取得的所得，应按&ldquo;稿酬所得&rdquo;项目征收个人所得税。 <br />
        出版社的专业作者撰写、编写或翻译的作品，由本社以图书形式出版而取得的稿费收入，应按&ldquo;稿酬所得&rdquo;项目计征个人所得税。（国税函[2002]146号） <br />
        例：李四一次获得稿酬收入32000元，其应纳税款应为： <br />
        32000&times;（1-20％）&times;20％&times;（1-30％）=3584（元）</div>
</div>
<div class="descBlock" id="divDesc6">
    <div class="descTitle">特许权使用费所得计税规定</div>
    <div class="descContent"> &nbsp;&nbsp;&nbsp;&nbsp;特许权使用费所得指个人提供专利权、商标权、著作权、非专利技术以及其他特许权的使用权取得的所得。提供著作权的使用权取得的所得，不包括稿酬的所得，对于作者将自己的文字作品手稿原件或复印件公开拍卖（竞价）取得的所得，应按特许权使用费所得项目纳税。个人取得特许权的经济赔偿收入，应按&ldquo;特许权使用费所得&rdquo;纳税。<br />
        特许权使用费所得，以一项特许权的一次许可使用所取得的收入为一次，定额或定率减除规定费用后的余额为应纳税所得额。每次收入不超过4000元的，定额减除费用800元；每次收入在4000以上的，定率减除20%的费用。特许权使用费所得适用20%的比例税率。<br />
        个人所得税应纳税额 = 应纳税所得额 &times; 适用税率。<br />
        对个人从事技术转让中所支付的中介费，若能提供有效的合法凭证，允许从所得中扣除。（财税字[1994]020号）<br />
        作者将自己的文字作品手稿原件或复印件拍卖取得的所得，按照&ldquo;特许权使用费&rdquo;所得项目缴纳个人所得税（国税发〔1994〕089号）。</div>
</div>
<div class="descBlock" id="divDesc7">
    <div class="descTitle">利息、股息、红利所得计税规定</div>
    <div class="descContent">&nbsp;&nbsp;&nbsp;&nbsp;利息、股息、红利所得是指个人拥有债权、股权而取得的利息、股息、红利所得。<br />
        利息、股息、红利所得以每次收入额为应纳税所得额，适用比例税率，税率为20%。<br />
        个人所得税应纳税额 = 应纳税所得额 &times; 适用税率。<br />
        除个人独资企业、合伙企业以外的其他企业的个人投资者，以企业资金为本人、家庭成员及相关人员支付与生产经营无关的消费性支出以及购买汽车、住房等财产性支出，视为企业对个人投资者的红利分配，按&ldquo;利息、股息、红利所得&rdquo;项目计征个人所得税。<br />
        纳税年度内个人投资者从其投资企业（个人独资企业、合伙企业除外）借款，在该纳税年度终了后既不归还，又未用于企业生产经营的，其未归还的借款可视为企业对个人投资者的红利分配，按&ldquo;利息、股息、红利所得&rdquo;项目计征个人所得税。（财税〔2003〕158号）<br />
        个体工商户与企业联营而分得的利润，按利息、股息、红利所得项目征收个人所得税。（财税字[1994]020号）</div>
</div>
<div class="descBlock" id="divDesc8">
    <div class="descTitle">财产租赁所得计税规定</div>
    <div class="descContent">&nbsp;&nbsp;&nbsp;&nbsp;财产租赁所得是指个人出租建筑物、土地使用权、机器设备、车船以及其他财产取得的所得。<br />
        （1）财产租赁所得以一个月内取得的收入为一次，定额或定率减除规定费用后的余额为应纳税所得额。每次收入不超过4000元的，定额减除费用800元；每次收入在4000以上的，定率减除20%的费用。财产租赁所得适用20%的比例税率。<br />
        对个人出租房屋取得的所得暂减按10%的税率征收个人所得税。（财税[2005]125号）<br />
        个人所得税应纳税额 = 应纳税所得额 &times; 适用税率。<br />
        （2）纳税人在出租财产过程中缴纳的税金、教育费附加，可持完税凭证，从其财产租赁收入中扣除。纳税人提供准确、有效凭证，由纳税人负担的出租财产实际开支的修缮费用，准予扣除。允许扣除的修缮费用，以每次800元为限，一次扣除不完的，准予在下一次继续扣除，直至扣完为止。 （国税发[1999]089号）<br />
        （3）在计算每月取得的财产租赁所得个人所得税时，应先扣除有关税金、教育费附加和修缮费用，再按税法规定减除800元或20%的法定费用，余额为应纳税所得额。<br />
        个人每月取得财产转租所得，可在扣除转租人支付的租金、税金和教育费附加后，再就其余额按税法规定计算征收个人所得税。</div>
</div>
<div class="descBlock" id="divDesc9">
    <div class="descTitle">财产转让所得计税规定</div>
    <div class="descContent">&nbsp;&nbsp;&nbsp;&nbsp;个人取得的各项财产转让所得，包括转让有价证券（除股票转让所得外）、股权、建筑物、土地使用权、机器设备、车船以及其他财产取得的所得，都要纳税。<br />
        财产转让所得，以一次转让财产的收入额减除财产原值和合理费用后的余额，为应纳税所得额，适用20%的比例税率。<br />
        个人所得税应纳税额 = 应纳税所得额 &times; 适用税率。<br />
        财产原值，是指：<br />
        （1）有价证券，为买入价以及买入时按照规定交纳的有关费用；<br />
        （2）建筑物，为建造费或者购进价格以及其他有关费用；<br />
        （3）土地使用权，为取得土地使用权所支付的金额、开发土地的费用以及其他有关费用；<br />
        （4）机器设备、车船，为购进价格、运输费、安装费以及其他有关费用；<br />
        （5）其他财产，参照以上方法确定。<br />
        纳税义务人未提供完整、准确的财产原值凭证，不能正确计算财产原值的，由主管税务机关核定其财产原值。<br />
        合理费用，是指卖出财产时按照规定支付的有关费用。</div>
</div>
<div class="descBlock" id="divDesc10">
    <div class="descTitle">偶然所得计税规定</div>
    <div class="descContent">&nbsp;&nbsp;&nbsp;&nbsp;偶然所得，是指个人得奖、中奖、中彩以及其他偶然性质的所得，包括现金、实物和有价证券。取得偶然所得的个人为纳税义务人；向个人支付偶然所得的单位为扣缴义务人。偶然所得应纳的个人所得税由支付单位实行源泉扣缴。 <br />
        偶然所得以每次取得的收入额为应纳税所得额，适用20%的比例税率。 <br />
        个人所得税应纳税额 = 应纳税所得额 &times; 适用税率。 <br />
        个人参加有奖储蓄取得的各种形式的中奖所得，属于机遇性的所得，应按照个人所得税法中&ldquo;偶然所得&rdquo;应税项目的规定征收个人所得税。支付该项所得的各级银行部门是税法规定的代扣代缴义务人。（国税函发[1995]98号） <br />
        个人购买社会福利有奖募捐奖券、体育彩票（奖券）一次中奖收入在10000元以下（含10000元）的，暂免征收个人所得税；超过10000元的，应按税法规定全额征税。（国税发[1994]127号、国税函发[1998]803号、财税[1998]12号） <br />
        个人因参加企业的有奖销售活动而取得的赠品所得，应按&ldquo;偶然所得&rdquo;项目，由举办有奖销售活动的企业（单位）代扣代缴个人所得税。（国税函[2002]629号）</div>
</div></td>
</tr>
</table></td>
</tr>
</table>
<%@include file="foot.jsp"%>
</body>
</html>