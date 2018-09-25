package com.manage.service;

import java.util.List;

import com.manage.dao.model.Coupon;
import com.manage.dao.model.CouponExample;

public interface ICouponService {
	int countByExample(CouponExample example);

    int deleteByExample(CouponExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Coupon record);

    List<Coupon> selectByExample(CouponExample example);

    Coupon selectByPrimaryKey(Long id);

    int updateByExampleSelective(Coupon record, CouponExample example);

    int updateByPrimaryKeySelective(Coupon record);

}
