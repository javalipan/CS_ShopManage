package com.manage.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.OrderMapper;
import com.manage.dao.model.Order;
import com.manage.dao.model.OrderExample;
import com.manage.query.mapper.OrderQueryMapper;
import com.manage.query.model.OrderQuery;
import com.manage.service.IOrderService;

@Service
public class OrderService implements IOrderService {

	@Autowired
	private OrderMapper orderMapper;
	@Autowired
	private OrderQueryMapper orderQueryMapper;
	
	public int countByExample(OrderExample example) {
		return orderMapper.countByExample(example);
	}

	public int deleteByExample(OrderExample example) {
		return orderMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return orderMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Order record) {
		return orderMapper.insertSelective(record);
	}

	public List<Order> selectByExample(OrderExample example) {
		return orderMapper.selectByExample(example);
	}

	public Order selectByPrimaryKey(Long id) {
		return orderMapper.selectByPrimaryKey(id);
	}
	
	public int updateByExampleSelective(Order record, OrderExample example) {
		return orderMapper.updateByExampleSelective(record, example);
	}

	public int updateByPrimaryKeySelective(Order record) {
		return orderMapper.updateByPrimaryKeySelective(record);
	}

	public OrderQuery selectOrderQueryById(Long id) {
		return orderQueryMapper.selectOrderQueryById(id);
	}

	public OrderQuery selectOrderQueryByCode(String code) {
		return orderQueryMapper.selectOrderQueryByCode(code);
	}

	public List<OrderQuery> selectByOrderQuery(OrderQuery orderQuery) {
		return orderQueryMapper.selectByOrderQuery(orderQuery);
	}

	public Integer countByOrderQuery(OrderQuery orderQuery) {
		return orderQueryMapper.countByOrderQuery(orderQuery);
	}

	public Map<String, Object> sumOrder(OrderQuery orderQuery) {
		return orderQueryMapper.sumOrder(orderQuery);
	}

	public List<Map<String, Object>> sumByOldOrNew(String year) {
		return orderQueryMapper.sumByOldOrNew(year);
	}

	public List<Map<String, Object>> sumBrand(String startTime, String endTime,
			Long brandid) {
		return orderQueryMapper.sumBrand(startTime, endTime, brandid);
	}

	public List<Map<String, Object>> sumColor(String startTime, String endTime,
			Long brandid) {
		return orderQueryMapper.sumColor(startTime, endTime, brandid);
	}

	public List<Map<String, Object>> sumSize(String startTime, String endTime,
			Long brandid) {
		return orderQueryMapper.sumSize(startTime, endTime, brandid);
	}

	public List<Map<String, Object>> sumStyle(String startTime, String endTime,
			Long brandid) {
		return orderQueryMapper.sumStyle(startTime, endTime, brandid);
	}

	public List<OrderQuery> selectByOrderQuery2(OrderQuery orderQuery) {
		return orderQueryMapper.selectByOrderQuery2(orderQuery);
	}

	public Integer countByOrderQuery2(OrderQuery orderQuery) {
		return orderQueryMapper.countByOrderQuery2(orderQuery);
	}

}
