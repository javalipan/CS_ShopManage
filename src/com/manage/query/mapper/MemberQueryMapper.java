package com.manage.query.mapper;

import java.util.List;
import java.util.Map;

import com.manage.query.model.MemberQuery;

public interface MemberQueryMapper {

	public List<MemberQuery> selectByMemberQuery(MemberQuery memberQuery);
	
	public Integer countByMemberQuery(MemberQuery memberQuery);
	
	public List<MemberQuery> selectSumByMemberQuery(MemberQuery memberQuery);
	
	public Integer countSumByMemberQuery(MemberQuery memberQuery);
	
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
