package com.manage.service;

import java.util.List;
import java.util.Map;

import com.manage.dao.model.Order;
import com.manage.dao.model.OrderExample;
import com.manage.query.model.OrderQuery;

public interface IOrderService {

	int countByExample(OrderExample example);

    int deleteByExample(OrderExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Order record);

    List<Order> selectByExample(OrderExample example);

    Order selectByPrimaryKey(Long id);
    
    int updateByExampleSelective(Order record, OrderExample example);

    int updateByPrimaryKeySelective(Order record);

    /** 
	* 根据id查询订单
	* @param id
	* @return   OrderQuery 
	* @author lipan@cqrainbowsoft.com    
	*/
	public OrderQuery selectOrderQueryById(Long id);
	/** 
	 * 根据code查询订单
	 * @param code
	 * @return   OrderQuery 
	 * @author lipan@cqrainbowsoft.com    
	 */
	public OrderQuery selectOrderQueryByCode(String code);
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
    public List<Map<String, Object>> sumByOldOrNew(String year);
    
    /**
     * 统计各品牌销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumBrand(String startTime,String endTime,Long brandid);
    /**
     * 统计各颜色销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumColor(String startTime,String endTime,Long brandid);
    /**
     * 统计各尺码销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumSize(String startTime,String endTime,Long brandid);
    /**
     * 统计各风格销售额及利润
     * @param startTime :开始时间
     * @param endTime ：结束时间
     * @param brandid ：品牌id
     * @return List<Map<String, Object>>
     */
    public List<Map<String, Object>> sumStyle(String startTime,String endTime,Long brandid);
}
