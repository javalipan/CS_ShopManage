package com.manage.query.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.manage.query.model.OrderDetailQuery;

public interface OrderDetailQueryMapper {

	/** 
	* 根据id查询订单详情
	* @param id
	* @return   OrderDetailQuery 
	* @author lipan@cqrainbowsoft.com    
	*/
	public OrderDetailQuery selectOrderDetailQueryById(@Param("id")Long id);
    /** 
    * 查询订单详情列表
    * @param orderDetailQuery
    * @return    List<OrderDetailQuery> 
    * @author lipan@cqrainbowsoft.com    
    */
    public List<OrderDetailQuery> selectByOrderDetailQuery(OrderDetailQuery orderDetailQuery);
    /** 
    * 查询订单详情条数
    * @param orderDetailQuery
    * @return   Integer 
    * @author lipan@cqrainbowsoft.com    
    */
    public Integer countByOrderDetailQuery(OrderDetailQuery orderDetailQuery);
}
