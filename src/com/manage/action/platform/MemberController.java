package com.manage.action.platform;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.constant.CommonConstant;
import com.manage.dao.mapper.LevelSettingMapper;
import com.manage.dao.model.Code;
import com.manage.dao.model.LevelSetting;
import com.manage.dao.model.LevelSettingExample;
import com.manage.dao.model.Member;
import com.manage.dao.model.MemberAddress;
import com.manage.dao.model.MemberAddressExample;
import com.manage.dao.model.MemberExample;
import com.manage.dao.model.MemberLabel;
import com.manage.dao.model.MemberLabelExample;
import com.manage.dao.model.MemberTypeChange;
import com.manage.dao.model.MemberTypeChangeExample;
import com.manage.dao.model.PointLog;
import com.manage.dao.model.Recharge;
import com.manage.dao.model.RechargeExample;
import com.manage.dao.model.RechargeRule;
import com.manage.dao.model.RechargeRuleExample;
import com.manage.dao.model.Region;
import com.manage.query.model.MemberQuery;
import com.manage.service.ICodeService;
import com.manage.service.IMemberAddressService;
import com.manage.service.IMemberLabelService;
import com.manage.service.IMemberService;
import com.manage.service.IMemberTypeChangeService;
import com.manage.service.IPointLogService;
import com.manage.service.IRechargeRuleService;
import com.manage.service.IRechargeService;
import com.manage.service.IRegionService;
import com.manage.util.Pager;

/**
 * 会员管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/member")
public class MemberController extends BaseController{
	
	@Autowired
	private IMemberService memberService;
	@Autowired
	private IRegionService regionService;
	@Autowired
	private IPointLogService pointLogService;
	@Autowired
	private IRechargeRuleService rechargeRuleService;
	@Autowired
	private IRechargeService rechargeService;
	@Autowired
	private IMemberTypeChangeService memberTypeChangeService;
	@Autowired
	private LevelSettingMapper levelSettingMapper;
	@Autowired
	private ICodeService codeService;
	@Autowired
	private IMemberLabelService memberLabelService;
	@Autowired
	private IMemberAddressService memberAddressService;
	
	
	
	/** 
	* 会员 
	* @return    
	* @author lipan@cqrainbowsoft.com    
	*/
	@RequestMapping(value="/initMemberList.action")
	public String initMemberList(){
		return "member/memberlist";
	}
	
	@RequestMapping(value="/searchMember.action")
	@ResponseBody
	public String searchMember(ModelMap model,MemberQuery memberQuery,Pager pager,String orderBy){
		if(StringUtils.isBlank(orderBy)){
			orderBy="registertime desc";
		}
		memberQuery.setOrderBy(orderBy);
		memberQuery.setPager(pager);
		List<MemberQuery> members=memberService.selectByMemberQuery(memberQuery);
		for(MemberQuery mq:members){
			if(StringUtils.isNotBlank(mq.getHeadurl())&&!mq.getHeadurl().startsWith("http")){
				mq.setHeadurl(CommonConstant.WEIXIN_URL+mq.getHeadurl());
			}
		}
		int count=memberService.countByMemberQuery(memberQuery);
		return DataGridJson(members,count);
	}
	
	@RequestMapping(value="/initMemberEdit.action")
	public String initMemberEdit(ModelMap model,Long id){
		if(id!=null){
			Member member=memberService.selectByPrimaryKey(id);
			model.put("member", member);
			if(member.getAddressid()!=null){
				Region region=regionService.selectByCode(member.getAddressid());
				model.put("region", region);
			}
			
			MemberAddressExample memberAddressExample=new MemberAddressExample();
			memberAddressExample.createCriteria().andMemberidEqualTo(member.getId());
			List<MemberAddress> memberAddresses=memberAddressService.selectByExample(memberAddressExample);
			model.put("memberAddresses", memberAddresses);
		}
		
		
		
		List<LevelSetting> levelSettings=levelSettingMapper.selectByExample(new LevelSettingExample());
		model.put("levelSettings", levelSettings);
		
//		RegionExample regionExample=new RegionExample();
//		regionExample.createCriteria().andSuperiorcodeEqualTo(100000);
//		List<Region> regions=regionService.selectByExample(regionExample);
//		model.put("provinces", regions);
		return "member/memberEdit";
	}
	
	@RequestMapping(value="/getAllMembers.action")
	@ResponseBody
	public String getAllMembers(){
		MemberExample memberExample=new MemberExample();
		memberExample.createCriteria().andStatusEqualTo("0");
		List<Member> members=memberService.selectByExample(memberExample);
		List<Map<String, Object>> result=new ArrayList<Map<String,Object>>();
		for(Member member:members){
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("id", member.getId());
			map.put("text", member.getNickname());
			result.add(map);
		}
		return JSONArray.fromObject(result).toString();
	}
	
	@RequestMapping(value="/saveMember.action")
	@ResponseBody
	public String saveMember(Member member){
		if(member.getId()!=null){
			memberService.updateByPrimaryKeySelective(member);
		}
		return "保存成功";
	}
	
	/**
	 * @param id :会员id
	 * @param type ：类型，1：减少，0：增加
	 * @param points
	 * @return
	 */
	@RequestMapping(value="/changePoints.action")
	@ResponseBody
	public String changePoints(Long id,String type,int points){
		Member member=memberService.selectByPrimaryKey(id);
		if("0".equals(type)){		//增加
			member.setMemberpoint(member.getMemberpoint()+points);
		}
		else{//减少
			member.setMemberpoint(member.getMemberpoint()-points);
		}
		memberService.updateByPrimaryKeySelective(member);		//修改会员积分
		
		PointLog pointLog=new PointLog();
		pointLog.setChangetime(new Date());
		pointLog.setMemberid(member.getId());
		pointLog.setPoint(points);
		pointLog.setReason("2");
		pointLog.setType(type);
		pointLogService.insertSelective(pointLog);		//插入积分变更记录
		return "操作成功";
	}
	
	@RequestMapping(value="/initRecharge.action")
	public String initRecharge(ModelMap model,Long id){
		Member member=memberService.selectByPrimaryKey(id);
		model.put("member", member);
		List<RechargeRule> rechargeRules=rechargeRuleService.selectByExample(new RechargeRuleExample());
		model.put("rechargeRules", rechargeRules);
		return "member/recharge";
	}
	
	@RequestMapping(value="/recharge.action")
	@ResponseBody
	public String recharge(Long id,Long ruleid,Integer amount,Integer giveamount,Double discount){
		if(ruleid!=null&&ruleid>0){
			RechargeRule rechargeRule=rechargeRuleService.selectByPrimaryKey(ruleid);
			memberService.recharge(id, rechargeRule.getAmount(), rechargeRule.getGiveamount(), rechargeRule.getDiscount());
		}
		else{
			memberService.recharge(id, amount, giveamount, discount);
		}
		return "充值成功";
	}
	
	@RequestMapping(value="/initRechargeRecord.action")
	public String initRechargeRecord(ModelMap model,Long id){
		RechargeExample rechargeExample=new RechargeExample();
		rechargeExample.setOrderByClause("dealTime desc");
		rechargeExample.createCriteria().andStatusEqualTo("1").andMemberidEqualTo(id);
		List<Recharge> recharges=rechargeService.selectByExample(rechargeExample);
		model.put("recharges", recharges);
		return "member/rechargeRecord";
	}
	
	@RequestMapping(value="/initTypeChangeRecord.action")
	public String initTypeChangeRecord(ModelMap model,Long id){
		Member member=memberService.selectByPrimaryKey(id);
		MemberTypeChangeExample memberTypeChangeExample=new MemberTypeChangeExample();
		memberTypeChangeExample.setOrderByClause("changetime desc");
		memberTypeChangeExample.createCriteria().andMemberidEqualTo(id);
		List<MemberTypeChange> memberTypeChanges=memberTypeChangeService.selectByExample(memberTypeChangeExample);
		model.put("records", memberTypeChanges);
		model.put("member", member);
		return "member/typeChangeRecord";
	}
	
	@RequestMapping(value="/initMemberLabels.action")
	public String initMemberLabels(ModelMap model,Long id){
		MemberLabelExample memberLabelExample=new MemberLabelExample();
		memberLabelExample.createCriteria().andMemberidEqualTo(id);
		List<MemberLabel> memberLabels=memberLabelService.selectByExample(memberLabelExample);
		model.put("memberLabels", memberLabels);
		
		List<Code> codes=codeService.getCodesByType(CommonConstant.LABELS);
		model.put("codes", codes);
		model.put("id", id);
		return "member/memberLabel";
	}
	
	@RequestMapping(value="/deleteLabel.action")
	@ResponseBody
	public String deleteLabel(Long id){
		memberLabelService.deleteByPrimaryKey(id);
		return "删除成功";
	}
	
	@RequestMapping(value="/saveLabel.action")
	@ResponseBody
	public String saveLabel(MemberLabel memberLabel){
		MemberLabelExample memberLabelExample=new MemberLabelExample();
		memberLabelExample.createCriteria().andMemberidEqualTo(memberLabel.getMemberid()).andLabelnameEqualTo(memberLabel.getLabelname());
		int count=memberLabelService.countByExample(memberLabelExample);
		Map<String, Object> result=new HashMap<String, Object>();
		if(count>0){
			result.put("success", false);
			result.put("msg", "不能重复添加");
			return JSONObject.fromObject(result).toString();
		}
		memberLabelService.insertSelective(memberLabel);
		result.put("success", true);
		result.put("data", memberLabel);
		return JSONObject.fromObject(result).toString();
	}
}
