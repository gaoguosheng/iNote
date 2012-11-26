package com.ggs.util;

import java.io.ByteArrayOutputStream;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-7-7
 * Time: 下午4:50
 * To change this template use File | Settings | File Templates.
 */
public class Enc {
    private static final String VERIABLY =
            "abcdefghijklmnopqrstuvwxyz"+
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
                    ".-*_";
    public static String urlEncode(
            String s, String charset) throws Exception {
        // abc
        byte[] bytes =
                s.getBytes(charset);
        StringBuilder sb = new StringBuilder();
        outer:
        for(int i=0;i<bytes.length;i++) {
            byte b = bytes[i];
            if(b == ' ') {
                sb.append('+');
                continue outer;
            }
            for(int j=0;j<VERIABLY.length();j++) {
                if(VERIABLY.charAt(j) == b) {
                    sb.append((char) b);
                    continue outer;
                }
            }
            String hex = Integer.toHexString(b&0x000000ff);
            if(hex.length() == 1) hex = '0'+hex;
            hex = '%'+hex;
            sb.append(hex);
        }
        return sb.toString();
    }

    public static String urlDecode(String s,String charset) throws Exception {
        ByteArrayOutputStream out =
                new ByteArrayOutputStream();

        for(int i=0;i<s.length();i++) {
            char c = s.charAt(i);
            if(c == '%') {
                // %f8
                String hex = "";
                hex += s.charAt(++i);
                hex += s.charAt(++i);
                int n = Integer.parseInt(hex, 16);
                out.write(n);
            } else {
                if(VERIABLY.indexOf(c) != -1) {
                    out.write(c);
                    continue;
                }
                if('+' == c) {
                    out.write(' ');
                    continue;
                }
            }
        }
        byte[] data = out.toByteArray();
        return new String(data,charset);
    }

    public static void main(String[] args) throws Exception {
        String s = urlEncode("123","UTF-8");
        System.out.println(s);

        s = urlDecode(s, "UTF-8");
        System.out.println(s);
    }
}