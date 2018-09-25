package com.manage.service;

import java.util.List;

import com.manage.dao.model.Type;
import com.manage.dao.model.TypeExample;

public interface ITypeService {
	int countByExample(TypeExample example);

    int deleteByExample(TypeExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Type record);

    List<Type> selectByExample(TypeExample example);

    Type selectByPrimaryKey(Long id);
    
    Type selectByCode(String code);

    int updateByPrimaryKeySelective(Type record);

}
