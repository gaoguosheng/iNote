package com.ggs.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-6-14
 * Time: 下午4:00
 * To change this template use File | Settings | File Templates.
 */
public class DateUtil {
    /**
     * 获取当前数字日期
     * */
    public static String getNumYearMonth(){
        return new SimpleDateFormat("yyyyMM").format(new Date());
    }

    /**
     * 获取本周日期
     * */
    public static String getCurrWeekDays(){
        StringBuilder s = new StringBuilder();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf  =new  SimpleDateFormat("MM.dd");
        int day_of_week = cal.get(Calendar.DAY_OF_WEEK) - 2;
        cal.add(Calendar.DATE, -day_of_week);
        s.append(sdf.format(cal.getTime()));
        s.append("-");
        cal.add(Calendar.DATE, 6);
        s.append(sdf.format(cal.getTime()));
        return s.toString();
    }

    /**
     * 获取指定星期的日期
     * */
    public static String getCurrWeekDay(int day){
        StringBuilder s = new StringBuilder();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf  =new  SimpleDateFormat("yyyy-MM-dd");
        int day_of_week = cal.get(Calendar.DAY_OF_WEEK) - 2;
        cal.add(Calendar.DATE, -day_of_week);
        cal.add(Calendar.DATE, day);
        s.append(sdf.format(cal.getTime()));
        return s.toString();
    }

    /**
     * 获取指定格式日期
     * */
    public static String getDate(String format){
        return new SimpleDateFormat(format).format(new Date());
    }

    /**
     * 获取本年第几周
     * */
    public static int getWeekOfYear(){
        String result="";
        Date d = new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        //System.out.println(c.get(Calendar.WEEK_OF_MONTH)); // 当前是当月的第几周
        return c.get(Calendar.WEEK_OF_YEAR);  // 当前是当年的第几周
    }

    /**
     * 计算时间差
     * @return 返回分钟数
     * */
    public static long timeDiff(String date1,String date2){
        Date d1;
        Date d2;
        long time=0;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try {
            d1 = sdf.parse(date1);
            d2=sdf.parse(date2);
            time = d1.getTime()-d2.getTime();
            time=(time/1000/60);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return time;
    }

    public static void main(String[] args ) {
        System.out.print(timeDiff("2012-10-31 09:50","2012-10-31 09:00"));
    }

}
