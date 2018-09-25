package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.OrderDetailMapper;
import com.manage.dao.model.OrderDetail;
import com.manage.dao.model.OrderDetailExample;
import com.manage.query.mapper.OrderDetailQueryMapper;
import com.manage.query.model.OrderDetailQuery;
import com.manage.service.IOrderDetailService;

@Service
public class OrderDetailService implements IOrderDetailService {

	@Autowired
	private OrderDetailMapper orderDetailMapper;
	@Autowired
	private OrderDetailQueryMapper orderDetailQueryMapper;
	
	public int countByExample(OrderDetailExample example) {
		return orderDetailMapper.countByExample(example);
	}

	public int deleteByExample(OrderDetailExample example) {
		return orderDetailMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return orderDetailMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(OrderDetail record) {
		return orderDetailMapper.insertSelective(record);
	}

	public List<OrderDetail> selectByExample(OrderDetailExample example) {
		return orderDetailMapper.selectByExample(example);
	}

	public OrderDetail selectByPrimaryKey(Long id) {
		return orderDetailMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(OrderDetail record) {
		return orderDetailMapper.updateByPrimaryKeySelective(record);
	}

	public OrderDetailQuery selectOrderDetailQueryById(Long id) {
		return orderDetailQueryMapper.selectOrderDetailQueryById(id);
	}

	public List<OrderDetailQuery> selectByOrderDetailQuery(
			OrderDetailQuery orderDetailQuery) {
		return orderDetailQueryMapper.selectByOrderDetailQuery(orderDetailQuery);
	}

	public Integer countByOrderDetailQuery(OrderDetailQuery orderDetailQuery) {
		return orderDetailQueryMapper.countByOrderDetailQuery(orderDetailQuery);
	}

}
