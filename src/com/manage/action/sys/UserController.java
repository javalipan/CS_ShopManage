package com.manage.action.sys;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.constant.CommonConstant;
import com.manage.dao.model.User;
import com.manage.dao.model.UserExample;
import com.manage.service.IUserService;
import com.manage.util.CommonUtil;
import com.manage.util.Pager;

@Controller
@RequestMapping(value="user")
public class UserController extends BaseController{
	
	private final String DEFAULT_PASS="123456";
	
	@Autowired
	private IUserService userService;

	@RequestMapping(value="/initUserList.action")
	public String initUserList(){
		return "user/userlist";
	}
	
	@RequestMapping(value="/searchUsers.action")
	@ResponseBody
	public String searchUsers(ModelMap model,User user,Pager pager){
		UserExample userExample=new UserExample();
		UserExample.Criteria crit=userExample.createCriteria();
		if(StringUtils.isNotEmpty(user.getName())){
			crit.andNameLike("%"+user.getName()+"%");
		}
		if(StringUtils.isNotEmpty(user.getLoginname())){
			crit.andLoginnameLike("%"+user.getLoginname()+"%");
		}
		int count=userService.countByExample(userExample);
		userExample.setPager(pager);
		List<User> userList=userService.selectByExample(userExample);
		return DataGridJson(userList, count);
	}
	
	@RequestMapping(value="/initUserEdit.action")
	public String initUserEdit(ModelMap model,User user){
		if(user!=null&&user.getId()!=null){
			user=userService.selectByPrimaryKey(user.getId());
			model.put("user", user);
		}
		return "user/userEdit";
	}
	
	@RequestMapping(value="/saveUser.action")
	@ResponseBody
	public String saveUser(ModelMap model,User user){
		if(StringUtils.isNotEmpty(user.getPassword())){
			try {
				user.setPassword(CommonUtil.md5(user.getPassword()));
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		if(StringUtils.isEmpty(user.getId())){		//添加
			user.setId(getUUID());
			user.setCreatetime(new Date());
			userService.insert(user);
		}
		else{		//修改
			userService.updateByPrimaryKeySelective(user);
		}
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteUser.action")
	@ResponseBody
	public String deleteUser(ModelMap model,String ids){
		userService.deleteByIds(ids);
		return "删除成功";
	}
	
	@RequestMapping(value="/resetPassword.action")
	@ResponseBody
	public String resetPassword(ModelMap model,User user){
		try {
			user.setPassword(CommonUtil.md5(DEFAULT_PASS));
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		userService.updateByPrimaryKeySelective(user);
		return "密码已经重置为"+DEFAULT_PASS;
	}
	
	@RequestMapping(value="/changeStatus.action")
	@ResponseBody
	public String changeStatus(ModelMap model,User user){
		user=userService.selectByPrimaryKey(user.getId());
		if(CommonConstant.STATUS_NORMAL.equals(user.getStatus())){
			user.setStatus(CommonConstant.STATUS_DISABLE);
		}
		else{
			user.setStatus(CommonConstant.STATUS_NORMAL);
		}
		userService.updateByPrimaryKeySelective(user);
		return "操作成功!";
	}
	
	@RequestMapping(value="/loginnameExists.do")
	@ResponseBody
	public String loginnameExists(String loginname){
		UserExample userExample=new UserExample();
		UserExample.Criteria crit=userExample.createCriteria();
		crit.andLoginnameEqualTo(loginname);
		List<User> users=userService.selectByExample(userExample);
		if(users.size()>0){
			return "true";
		}
		return "false";
	}
	
	@RequestMapping(value="/initModifyPassword.action")
	public String initModifyPassword(){
		return "user/modifyPassword";
	}
	
	@RequestMapping(value="/modifyPass.action")
	@ResponseBody
	public String modifyPass(String oldpass,String newpass) throws NoSuchAlgorithmException, UnsupportedEncodingException{
		User user=getSessionInfo();
		if(!user.getPassword().equals(CommonUtil.md5(oldpass))){
			return "旧密码输入错误";
		}
		user.setPassword(CommonUtil.md5(newpass));
		if(userService.updateByPrimaryKeySelective(user)>0){
			return "操作成功!";
		}
		return "";
	}
}
