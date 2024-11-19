package com.ITSproj.interceptor;

import javax.servlet.http.HttpServletRequest;

public class DestiationPath {
	private String destPath;  
	
	public void setDestPath(HttpServletRequest request) {
		String uri = request.getRequestURI();
		String queryString = request.getQueryString(); // ? 媛� 鍮좎쭊 �긽�깭濡� 諛섑솚�맖

		this.destPath = (queryString == null) ? uri : uri + "?" + queryString;
		
		request.getSession().setAttribute("destPath", this.destPath);

	}
}

