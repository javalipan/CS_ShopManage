package com.manage.query.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.manage.query.model.OrderQuery;

public interface OrderQueryMapper {

	/** 
	* 根据id查询订单
	* @param id
	* @return   OrderQuery 
	* @author lipan@cqrainbowsoft.com    
	*/
	public OrderQuery selectOrderQueryById(@Param("id")Long id);
	/** 
	 * 根据code查询订单
	 * @param code
	 * @return   OrderQuery 
	 * @author lipan@cqrainbowsoft.com    
	 */
	public OrderQuery selectOrderQueryByCode(@Param("code")String code);
    /** 
    * 查询订单列表
    * @param orderQuery
    * @return    List<OrderQuery> 
    * @author lipan@cqrainbowsoft.com    
    */
    public List<OrderQuery> selectByOrderQuery(OrderQuery orderQuery);
    /** 
    * 查询订单条数
    * @param orderQuery
    * @return   Integer 
    * @author lipan@cqrainbowsoft.com    
    */
    public Integer countByOrderQuery(OrderQuery orderQuery);
    /** 
     * 查询订单表2列表
     * @param orderQuery
     * @return    List<OrderQuery> 
     * @author lipan@cqrainbowsoft.com    
     */
    public List<OrderQuery> selectByOrderQuery2(OrderQuery orderQuery);
    /** 
     * 查询订单表2条数
     * @param orderQuery
     * @return   Integer 
     * @author lipan@cqrainbowsoft.com    
     */
    public Integer countByOrderQuery2(OrderQuery orderQuery);
    /**
     * 订单统计
     * @param orderQuery
     * @return
     */
    public Map<String, Object> sumOrder(OrderQuery orderQuery);
    
    /**
     * 统计各类会员订单数
     * @param year
     * @return
     */
    public List<Map<String, Object>> sumByOldOrNew(@Param("year") String year);
    /**
     * 统计各品牌销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumBrand(@Param("startTime")String startTime,@Param("endTime")String endTime,@Param("brandid")Long brandid);
    /**
     * 统计各颜色销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumColor(@Param("startTime")String startTime,@Param("endTime")String endTime,@Param("brandid")Long brandid);
    /**
     * 统计各尺码销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumSize(@Param("startTime")String startTime,@Param("endTime")String endTime,@Param("brandid")Long brandid);
    /**
     * 统计各风格销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumStyle(@Param("startTime")String startTime,@Param("endTime")String endTime,@Param("brandid")Long brandid);
}
