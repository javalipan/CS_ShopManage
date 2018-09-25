package com.manage.util.interceptor;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.manage.dao.model.Menu;
import com.manage.dao.model.MenuExample;
import com.manage.dao.model.User;
import com.manage.query.model.MenuQuery;
import com.manage.service.IMenuService;


public class MyHandlerInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private IMenuService menuService;
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		String url = request.getRequestURI();
		if(url.endsWith(".action")){	//拦截后台管理
			if(request.getSession().getAttribute("USER_INFO")==null){
				String path = request.getContextPath();
				String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
				response.sendRedirect(basePath+ "/manage/initLogin.do");	
				return false;
			}
			else{
				User user=(User) request.getSession().getAttribute("USER_INFO");
				String uri=request.getRequestURI();
				MenuExample menuExample=new MenuExample();
				MenuExample.Criteria crit=menuExample.createCriteria();
				uri=uri.replace(request.getContextPath(), "");
				if(uri.charAt(0)=='/'){
					uri=uri.replaceFirst("/", "");
				}
				crit.andUrlLike("%"+uri+"%");
				List<Menu> menus=menuService.selectByExample(menuExample);
				
				MenuQuery menuQuery=new MenuQuery();
				menuQuery.setUserid(user.getId());
				List<MenuQuery> rights=menuService.selectMenuPermission(menuQuery);
				List<String> rightids=new ArrayList<String>();
				for(MenuQuery mq:rights){
					rightids.add(mq.getId());
				}
				if(menus!=null&&menus.size()>0){
					for(Menu menu:menus){
						if(!rightids.contains(menu.getId())){		//没有权限
							throw new Exception("No Permission");
						}
					}
				}
			}
		}
		return true;
	}
	
}
