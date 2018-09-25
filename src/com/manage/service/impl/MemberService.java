package com.manage.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.MemberMapper;
import com.manage.dao.mapper.RechargeMapper;
import com.manage.dao.model.LevelSetting;
import com.manage.dao.model.Member;
import com.manage.dao.model.MemberExample;
import com.manage.dao.model.Recharge;
import com.manage.query.mapper.LevelSettingQueryMapper;
import com.manage.query.mapper.MemberQueryMapper;
import com.manage.query.model.MemberQuery;
import com.manage.service.IMemberService;
import com.manage.util.MathUtils;
import com.manage.util.NumberUtil;

@Service
public class MemberService implements IMemberService {

	@Autowired
	private MemberMapper memberMapper;
	@Autowired
	private MemberQueryMapper memberQueryMapper;
	@Autowired
	private RechargeMapper rechargeMapper;
	@Autowired
	private LevelSettingQueryMapper levelSettingQueryMapper;

	public int countByExample(MemberExample example) {
		return memberMapper.countByExample(example);
	}

	public int deleteByExample(MemberExample example) {
		return memberMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return memberMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Member record) {
		return memberMapper.insertSelective(record);
	}

	public List<Member> selectByExample(MemberExample example) {
		return memberMapper.selectByExample(example);
	}

	public Member selectByPrimaryKey(Long id) {
		return memberMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Member record) {
		return memberMapper.updateByPrimaryKeySelective(record);
	}

	public List<MemberQuery> selectSumByMemberQuery(MemberQuery memberQuery) {
		return memberQueryMapper.selectSumByMemberQuery(memberQuery);
	}

	public Integer countSumByMemberQuery(MemberQuery memberQuery) {
		return memberQueryMapper.countSumByMemberQuery(memberQuery);
	}

	public List<MemberQuery> selectByMemberQuery(MemberQuery memberQuery) {
		return memberQueryMapper.selectByMemberQuery(memberQuery);
	}

	public Integer countByMemberQuery(MemberQuery memberQuery) {
		return memberQueryMapper.countByMemberQuery(memberQuery);
	}

	public boolean recharge(Long id, Integer amount, Integer giveamount,
			Double discount) {
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmssSSS");
		Member member=memberMapper.selectByPrimaryKey(id);
		
		int addamount=amount+giveamount;
		Recharge recharge=new Recharge();
		recharge.setMemberid(member.getId());
		recharge.setAmount(amount);
		recharge.setGiveamount(giveamount);
		recharge.setRealamount(addamount);
		recharge.setDiscount(discount);
		recharge.setStatus("1");
		recharge.setPayway("3");
		Date now =new Date();
		recharge.setOrderno("C"+sdf.format(now));
		recharge.setCreatetime(now);
		recharge.setDealtime(now);
		rechargeMapper.insertSelective(recharge);
		
		
		member.setBalance(NumberUtil.toFixed(NumberUtil.add(addamount, member.getBalance()), 2));
		if(member.getDiscount()==null||discount<member.getDiscount()||member.getDiscount()==0){
			member.setDiscount(discount);
		}
		member.setTotalmoney(NumberUtil.toFixed(NumberUtil.add(member.getTotalmoney(),recharge.getAmount()), 2));		//累计消费
		LevelSetting levelSetting=levelSettingQueryMapper.getLevel(MathUtils.round(member.getTotalmoney(), 0));
		if(levelSetting.getGrade()!=member.getMemberlevel()){	//会员等级变动
			member.setMemberlevel(levelSetting.getGrade());		//会员等级
			member.setLevelchangetime(new Date());		//会员等级变动日期
			
			if(member.getDiscount()==null||member.getDiscount()==0){
				member.setDiscount(levelSetting.getDiscount());
			}
			else{
				member.setDiscount(member.getDiscount()>levelSetting.getDiscount()?levelSetting.getDiscount():member.getDiscount());
			}
		}
		
		memberMapper.updateByPrimaryKeySelective(member);
		return true;
	}

	public List<MemberQuery> memberAnalysis(MemberQuery memberQuery) {
		return memberQueryMapper.memberAnalysis(memberQuery);
	}

	public List<Map<String, Object>> sumBrand(MemberQuery memberQuery) {
		return memberQueryMapper.sumBrand(memberQuery);
	}

	public List<Map<String, Object>> sumColor(MemberQuery memberQuery) {
		return memberQueryMapper.sumColor(memberQuery);
	}

	public List<Map<String, Object>> sumSize(MemberQuery memberQuery) {
		return memberQueryMapper.sumSize(memberQuery);
	}

	public List<Map<String, Object>> sumStyle(MemberQuery memberQuery) {
		return memberQueryMapper.sumStyle(memberQuery);
	}

}
