package com.manage.action.platform;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.mapper.LevelSettingMapper;
import com.manage.dao.model.Coupon;
import com.manage.dao.model.CouponExample;
import com.manage.dao.model.LevelSetting;
import com.manage.dao.model.LevelSettingExample;
import com.manage.dao.model.Member;
import com.manage.dao.model.MemberCoupon;
import com.manage.dao.model.MemberExample;
import com.manage.service.ICouponService;
import com.manage.service.IMemberCouponService;
import com.manage.service.IMemberService;
import com.manage.util.Pager;

/**
 * 优惠券管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="coupon")
public class CouponController extends BaseController{

	@Autowired
	private ICouponService couponService;
	@Autowired
	private LevelSettingMapper levelSettingMapper;
	@Autowired
	private IMemberService memberService;
	@Autowired
	private IMemberCouponService memberCouponService;
	
	@RequestMapping(value="/initCouponList.action")
	public String initCouponList(){
		return "coupon/couponlist";
	}
	
	@RequestMapping(value="/searchCoupons.action")
	@ResponseBody
	public String searchCoupons(ModelMap model,Coupon coupon,Pager pager){
		CouponExample couponExample=new CouponExample();
		CouponExample.Criteria crit=couponExample.createCriteria();
		if(StringUtils.isNotBlank(coupon.getName())){
			crit.andNameLike("%"+coupon.getName()+"%");
		}
		couponExample.setOrderByClause("createtime desc");
		couponExample.setPager(pager);
		int count=couponService.countByExample(couponExample);
		List<Coupon> couponList=couponService.selectByExample(couponExample);
		return DataGridJson(couponList, count);
	}
	
	@RequestMapping(value="/initCouponEdit.action")
	public String initCouponEdit(ModelMap model,Coupon coupon){
		List<LevelSetting> levelSettings=levelSettingMapper.selectByExample(new LevelSettingExample());
		model.put("levelSettings", levelSettings);
		if(coupon!=null&&coupon.getId()!=null){
			coupon=couponService.selectByPrimaryKey(coupon.getId());
			model.put("coupon", coupon);
		}
		return "coupon/couponEdit";
	}
	
	@RequestMapping(value="/saveCoupon.action")
	@ResponseBody
	public String saveCoupon(ModelMap model,Coupon coupon){
		if(coupon.getId()==null||coupon.getId()==0){		//添加
			coupon.setCreatetime(new Date());
			coupon.setCreateuser(getSessionInfo().getId());
			coupon.setLeftamount(coupon.getAmount());
			couponService.insertSelective(coupon);
		}
		else{		//修改
			couponService.updateByPrimaryKeySelective(coupon);
		}
		return "保存成功!";
	}
	
	/** 
	*  发放优惠券
	* @param id :优惠券id
	* @param phone ：会员电话
	* @return String     
	*/
	@RequestMapping(value="/sendCoupon.action")
	@ResponseBody
	public String sendCoupon(Long id,String phone){
		if(id==null||StringUtils.isBlank(phone)){
			return "参数错误";
		}
		MemberExample memberExample=new MemberExample();
		memberExample.createCriteria().andPhoneEqualTo(phone);
		List<Member> members=memberService.selectByExample(memberExample);
		if(members.size()==0){
			return "会员不存在";
		}
		Member member=members.get(0);
		
		Coupon coupon=couponService.selectByPrimaryKey(id);
		if(coupon==null){
			return "优惠券不存在";
		}
		if(coupon.getLeftamount()<=0){
			return "优惠券数量不足!";
		}
		if(coupon.getGetgrade()>member.getMemberlevel()){
			return "会员等级不足兑换此券!";
		}
		if("0".equals(coupon.getStatus())){
			MemberCoupon memberCoupon=new MemberCoupon();
			memberCoupon.setMemberid(member.getId());
			SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmssSSS");
			memberCoupon.setCode("J"+sdf.format(new Date()));
			memberCoupon.setCouponid(coupon.getId());
			memberCoupon.setName(coupon.getName());
			memberCoupon.setSubtitle(coupon.getSubtitle());
			memberCoupon.setRemark(coupon.getRemark());
			memberCoupon.setLogourl(coupon.getLogourl());
			memberCoupon.setMoney(coupon.getMoney());
			if("0".equals(coupon.getTimetype())){		//优惠券有效期为固定日期
				memberCoupon.setStarttime(coupon.getStarttime());
				memberCoupon.setEndtime(coupon.getEndtime());
			}
			else{		//优惠券有效期为固定天数
				Calendar end=Calendar.getInstance();
				end.add(Calendar.DAY_OF_MONTH, coupon.getDays());
				Calendar calendar=Calendar.getInstance();
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				memberCoupon.setStarttime(calendar.getTime());
				memberCoupon.setEndtime(end.getTime());
			}
			memberCoupon.setStatus("0");
			memberCouponService.insertSelective(memberCoupon);		//发放会员优惠券
			
			coupon.setLeftamount(coupon.getLeftamount()-1);
			couponService.updateByPrimaryKeySelective(coupon);		//减少数量
		}
		else{
			return "优惠券状态不正常";
		}
		return "优惠券发放成功!";
	}
}
