package com.manage.service;

import java.util.List;

import com.manage.dao.model.Brand;
import com.manage.dao.model.BrandExample;

public interface IBrandService {

	int countByExample(BrandExample example);

    int deleteByExample(BrandExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Brand record);

    List<Brand> selectByExample(BrandExample example);

    Brand selectByPrimaryKey(Long id);

    int updateByExampleSelective(Brand record,BrandExample example);
    
    int updateByPrimaryKeySelective(Brand record);

    boolean saveBrand(Brand brand,String imgJson);
}
