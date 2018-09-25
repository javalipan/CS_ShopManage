package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.CouponMapper;
import com.manage.dao.model.Coupon;
import com.manage.dao.model.CouponExample;
import com.manage.service.ICouponService;

@Service
public class CouponService implements ICouponService {

	@Autowired
	private CouponMapper couponMapper;
	
	public int countByExample(CouponExample example) {
		return couponMapper.countByExample(example);
	}

	public int deleteByExample(CouponExample example) {
		return couponMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return couponMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Coupon record) {
		return couponMapper.insertSelective(record);
	}

	public List<Coupon> selectByExample(CouponExample example) {
		return couponMapper.selectByExample(example);
	}

	public Coupon selectByPrimaryKey(Long id) {
		return couponMapper.selectByPrimaryKey(id);
	}

	public int updateByExampleSelective(Coupon record, CouponExample example) {
		return couponMapper.updateByExampleSelective(record, example);
	}

	public int updateByPrimaryKeySelective(Coupon record) {
		return couponMapper.updateByPrimaryKeySelective(record);
	}

}
