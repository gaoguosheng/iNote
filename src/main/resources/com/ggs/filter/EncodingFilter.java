package com.ggs.filter;

import com.ggs.comm.Config;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



/**
 * 编码过滤器
 * */
@WebFilter(urlPatterns="*"+ Config.EXT)
public class EncodingFilter implements Filter {

	private String encoding="UTF-8";
	

	public void destroy() {
		

	}


	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {		
	
		
		//编码
		req.setCharacterEncoding(encoding);
		res.setCharacterEncoding(encoding);
		chain.doFilter(req, res);
	}


	public void init(FilterConfig arg0) throws ServletException {
		

	}

}
