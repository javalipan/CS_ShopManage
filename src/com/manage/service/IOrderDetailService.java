package com.manage.service;

import java.util.List;

import com.manage.dao.model.OrderDetail;
import com.manage.dao.model.OrderDetailExample;
import com.manage.query.model.OrderDetailQuery;

public interface IOrderDetailService {

	int countByExample(OrderDetailExample example);

    int deleteByExample(OrderDetailExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(OrderDetail record);

    List<OrderDetail> selectByExample(OrderDetailExample example);

    OrderDetail selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OrderDetail record);

    /** 
	* 根据id查询订单详情
	* @param id
	* @return   OrderDetailQuery 
	* @author lipan@cqrainbowsoft.com    
	*/
	public OrderDetailQuery selectOrderDetailQueryById(Long id);
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
