package com.manage.action;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.manage.dao.model.Region;
import com.manage.dao.model.RegionExample;
import com.manage.dao.model.User;
import com.manage.dao.model.UserExample;
import com.manage.query.model.MenuQuery;
import com.manage.service.ILogService;
import com.manage.service.IMenuService;
import com.manage.service.IRegionService;
import com.manage.service.ISequenceQueryService;
import com.manage.service.IUserService;
import com.manage.util.CommonUtil;

@Controller
@RequestMapping(value="/manage")
public class ManageController extends BaseController{
	
	@Autowired
	private IUserService userService;
	@Autowired
	private ILogService logService;
	@Autowired
	private IMenuService menuService;
	@Autowired
	private IRegionService regionService;
	@Autowired
	private ISequenceQueryService sequenceQueryService;
	
	@RequestMapping(value="/main.action")
	public String initManagePage(ModelMap model){
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
		User user=(User) request.getSession().getAttribute("USER_INFO");
		MenuQuery menuQuery=new MenuQuery();
		menuQuery.setUserid(user.getId());
		List<MenuQuery> menuQueries=menuService.selectMenuPermission(menuQuery);
		model.put("menus", menuQueries);
		return "main";
	}
	
	@RequestMapping(value="/initLogin.do")
	public String initLogin(){
		return "login";
	}
	
	@RequestMapping(value="/login.do")
	public String login(HttpServletRequest request,ModelMap model,User user){
		UserExample userExample=new UserExample();
		UserExample.Criteria crit=userExample.createCriteria();
		crit.andLoginnameEqualTo(user.getLoginname());
		try {
			crit.andPasswordEqualTo(CommonUtil.md5(user.getPassword()));
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		List<User> users=userService.selectByExample(userExample);
		if(users.size()>0){
			user=users.get(0);
			if("1".equals(user.getStatus())){
				model.put("errormes", "用户被禁用!");
				return "login";
			}
			request.getSession().setAttribute("USER_INFO", user);
			logService.insertLoginLog("用户"+user.getName()+"登录系统");
			return "redirect:/manage/main.action";
		}
		model.put("errormes", "用户名或密码错误!");
		return "login";
	}
	
	@RequestMapping(value="/logout.do")
	public String logout(HttpSession session){
		session.invalidate();
		return "login";
	}
	
	@RequestMapping(value="/getProvinces.action")
	@ResponseBody
	public String getProvinces(){
		RegionExample regionExample=new RegionExample();
		regionExample.createCriteria().andSuperiorcodeEqualTo(100000);
		List<Region> regions=regionService.selectByExample(regionExample);
		return JSONArray.fromObject(regions).toString();
	}
	
	@RequestMapping(value="/getChildrenArea.action")
	@ResponseBody
	public String getChildrenArea(Integer parent){
		RegionExample regionExample=new RegionExample();
		regionExample.createCriteria().andSuperiorcodeEqualTo(parent);
		List<Region> regions=regionService.selectByExample(regionExample);
		return JSONArray.fromObject(regions).toString();
	}
	
	/**
	 * 获取序列值
	 * @param seqname：序列名称
	 * @param formatnum : 补0数量，0为不补
	 * @return
	 */
	@RequestMapping(value="/getNextVal.action")
	@ResponseBody
	public String getNextVal(String seqname,int formatnum){
		Long current=sequenceQueryService.getSeqNextVal(seqname);
		if(formatnum==0){
			return String.valueOf(current);
		}
		else{
			return String.format("%0"+formatnum+"d", current);
		}
	}
}
