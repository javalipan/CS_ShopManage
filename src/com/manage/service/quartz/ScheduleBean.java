package com.manage.service.quartz;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.manage.constant.CommonConstant;
import com.manage.constant.LabelTypeEnum;
import com.manage.dao.mapper.GoodsMapper;
import com.manage.dao.mapper.LevelSettingMapper;
import com.manage.dao.mapper.MemberLabelMapper;
import com.manage.dao.mapper.MemberMapper;
import com.manage.dao.mapper.MemberTypeChangeMapper;
import com.manage.dao.mapper.SysSettingMapper;
import com.manage.dao.model.Goods;
import com.manage.dao.model.GoodsExample;
import com.manage.dao.model.LevelSetting;
import com.manage.dao.model.LevelSettingExample;
import com.manage.dao.model.Member;
import com.manage.dao.model.MemberExample;
import com.manage.dao.model.MemberLabel;
import com.manage.dao.model.MemberLabelExample;
import com.manage.dao.model.MemberTypeChange;
import com.manage.dao.model.SysSetting;
import com.manage.dao.model.SysSettingExample;
import com.manage.service.IDiscountQueryService;
import com.manage.util.DateUtil;

@Component
public class ScheduleBean {
	
	@Autowired
	private GoodsMapper goodsMapper;
	@Autowired
	private IDiscountQueryService discountQueryService;
	@Autowired
	private MemberMapper memberMapper;
	@Autowired
	private SysSettingMapper settingMapper;
	@Autowired
	private MemberTypeChangeMapper memberTypeChangeMapper;
	@Autowired
	private LevelSettingMapper levelSettingMapper;
	@Autowired
	private MemberLabelMapper memberLabelMapper;

	@Scheduled(cron="0 5 0 * * ?") // 定时任务，每天凌晨执行
	public void scheduleSecond() throws SchedulerException, ParseException {
		Date now=new Date();
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andStarttimeLessThanOrEqualTo(now).andEndtimeGreaterThanOrEqualTo(now).andIsdiscountEqualTo("1");
		Goods goods=new Goods();
		goods.setIsdiscount("2");
		goodsMapper.updateByExampleSelective(goods, goodsExample);		//将已开始未参与折扣的状态修改为折扣中
		
		GoodsExample goodsExample2=new GoodsExample();
		goodsExample2.createCriteria().andEndtimeLessThan(now).andIsdiscountEqualTo("2");
		List<Goods> goodList=goodsMapper.selectByExample(goodsExample2);
		String ids="";
		for(int i=0;i<goodList.size();i++){
			if(i==0){
				ids+=goodList.get(i).getId();
			}
			else{
				ids+=","+goodList.get(i).getId();
			}
		}
		if(StringUtils.isNotBlank(ids)){
			discountQueryService.calcelDiscount(ids, "3");		//过期的取消折扣
		}
		
		// 一年的会员降级
		Calendar calendar=Calendar.getInstance();
		calendar.add(Calendar.YEAR, -1);		//一年前的今天
		MemberExample memberExample=new MemberExample();
		memberExample.createCriteria().andLevelchangetimeLessThanOrEqualTo(calendar.getTime()).andMemberlevelGreaterThan(1);
		List<Member> members=memberMapper.selectByExample(memberExample);		//查询一年前升级的会员
		for(Member member:members){
			if(member.getLastbuytime()==null||member.getLastbuytime().compareTo(calendar.getTime())<0){		//一年内无购买行为
				member.setMemberlevel(member.getMemberlevel()-1);		
				member.setLevelchangetime(now);
				LevelSettingExample levelSettingExample=new LevelSettingExample();
				levelSettingExample.createCriteria().andGradeEqualTo(member.getMemberlevel()-1);
				List<LevelSetting> levelSettings=levelSettingMapper.selectByExample(levelSettingExample);
				if(levelSettings.size()>0){
					member.setDiscount(levelSettings.get(0).getDiscount());		//会员享受折扣为降级后折扣
				}
				
				memberMapper.updateByPrimaryKeySelective(member);	//会员降级
			}
		}
		
	} 
	
	/**
	 * 根据周期计算类型
	 * @throws SchedulerException
	 * @throws ParseException
	 */
	@Scheduled(cron="0 5 0 1/7 * ?") // 定时任务，每天凌晨执行
	public void changeType() throws SchedulerException, ParseException {
		System.out.println("***********根据周期计算类型定时器***********");
		MemberExample memberExample=new MemberExample();
		memberExample.createCriteria().andLastbuytimeIsNotNull();
		List<Member> members=memberMapper.selectByExample(memberExample);
		
		SysSettingExample sysSettingExample=new SysSettingExample();
		sysSettingExample.createCriteria().andTypekeyEqualTo(CommonConstant.BUYPERIOD);
		List<SysSetting> sysSettings=settingMapper.selectByExample(sysSettingExample);
		SysSetting setting=sysSettings.get(0);
		int buyperiod=Integer.parseInt(setting.getTypevalue());		//获取购买周期设置的天数
		Date now=new Date();
		
		for(Member member:members){
			double days=DateUtil.daysRange(member.getLastbuytime(), now);
			System.out.println(member.getId()+member.getNickname()+":"+days);
			if(days>buyperiod*3){		//超过3个购买周期
				if(!"S3".equals(member.getMembertype())){		//不是沉睡的改为沉睡
					MemberTypeChange memberTypeChange=new MemberTypeChange();
					memberTypeChange.setMemberid(member.getId());
					memberTypeChange.setBeforetype(member.getMembertype());
					memberTypeChange.setAftertype("S3");
					memberTypeChange.setChangetime(now);
					
					member.setMembertype("S3");
					memberMapper.updateByPrimaryKeySelective(member);		//更新类型
					memberTypeChangeMapper.insertSelective(memberTypeChange);		//插入类型变更记录
				}
			}
			else if(days>buyperiod*2){	//超过2个购买周期
				if(!"S2".equals(member.getMembertype())){		//不是半睡的改为半睡
					MemberTypeChange memberTypeChange=new MemberTypeChange();
					memberTypeChange.setMemberid(member.getId());
					memberTypeChange.setBeforetype(member.getMembertype());
					memberTypeChange.setAftertype("S2");
					memberTypeChange.setChangetime(now);
					
					member.setMembertype("S2");
					memberMapper.updateByPrimaryKeySelective(member);		//更新类型
					memberTypeChangeMapper.insertSelective(memberTypeChange);		//插入类型变更记录
				}
			}
			else if(days>buyperiod){		//超过1个购买周期
				if(!"S1".equals(member.getMembertype())){		//不是瞌睡的改为瞌睡
					MemberTypeChange memberTypeChange=new MemberTypeChange();
					memberTypeChange.setMemberid(member.getId());
					memberTypeChange.setBeforetype(member.getMembertype());
					memberTypeChange.setAftertype("S1");
					memberTypeChange.setChangetime(now);
					
					member.setMembertype("S1");
					memberMapper.updateByPrimaryKeySelective(member);		//更新类型
					memberTypeChangeMapper.insertSelective(memberTypeChange);		//插入类型变更记录
				}
			}
		}
		
		MemberExample memberExample2=new MemberExample();
		List<Member> memberList=memberMapper.selectByExample(memberExample2);
		for(Member member:memberList){
			MemberLabel timeLabel=new MemberLabel();		//入店资历
			timeLabel.setLabelname(DateUtil.getInTimeLabel(member.getRegistertime()));
			MemberLabelExample timeLabelExample=new MemberLabelExample();
			timeLabelExample.createCriteria().andMemberidEqualTo(member.getId()).andTypecodeEqualTo(LabelTypeEnum.LABELTYPE_TIME.getCode());
			memberLabelMapper.updateByExampleSelective(timeLabel, timeLabelExample);
			
			if(member.getLastbuytime()!=null){
				MemberLabel recentLabel=new MemberLabel();		//近期购物情境
				double days=DateUtil.daysRange(member.getLastbuytime(), new Date());
				if(days<=30){
					recentLabel.setLabelname("最近买家");
				}
				else if(days>30&&days<=90){
					recentLabel.setLabelname("中期未购物买家");
				}
				else{
					recentLabel.setLabelname("长期未购物买家");
				}
				
				MemberLabelExample recentLabelExample=new MemberLabelExample();
				recentLabelExample.createCriteria().andMemberidEqualTo(member.getId()).andTypecodeEqualTo(LabelTypeEnum.LABELTYPE_RECENT.getCode());
				memberLabelMapper.updateByExampleSelective(recentLabel, recentLabelExample);
			}
		}
	}
}
