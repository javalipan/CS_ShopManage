package com.manage.service;

import java.util.List;
import java.util.Map;

import com.manage.dao.model.Member;
import com.manage.dao.model.MemberExample;
import com.manage.query.model.MemberQuery;

public interface IMemberService {

	int countByExample(MemberExample example);

    int deleteByExample(MemberExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Member record);

    List<Member> selectByExample(MemberExample example);

    Member selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Member record);

    public List<MemberQuery> selectSumByMemberQuery(MemberQuery memberQuery);
	public Integer countSumByMemberQuery(MemberQuery memberQuery);
	
	public List<MemberQuery> selectByMemberQuery(MemberQuery memberQuery);
	public Integer countByMemberQuery(MemberQuery memberQuery);
	
	/**
	 * 充值
	 * @param id ：会员id
	 * @param amount ：金额
	 * @param giveamount ：赠送金额
	 * @param discount ：折扣
	 */
	public boolean recharge(Long id,Integer amount,Integer giveamount,Double discount);
	/**
	 * 会员分析
	 * @param memberQuery
	 */
	public List<MemberQuery> memberAnalysis(MemberQuery memberQuery);
	/**
     * 统计各品牌销售额及利润
     * @param memberQuery
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumBrand(MemberQuery memberQuery);
    /**
     * 统计各颜色销售额及利润
     * @param memberQuery
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumColor(MemberQuery memberQuery);
    /**
     * 统计各尺码销售额及利润
     * @param memberQuery
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumSize(MemberQuery memberQuery);
    /**
     * 统计各风格销售额及利润
     * @param memberQuery
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumStyle(MemberQuery memberQuery);
}
