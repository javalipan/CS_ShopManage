package com.manage.dao.mapper;

import com.manage.dao.model.MemberAddress;
import com.manage.dao.model.MemberAddressExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface MemberAddressMapper {
    int countByExample(MemberAddressExample example);

    int deleteByExample(MemberAddressExample example);

    int deleteByPrimaryKey(Long id);

    int insert(MemberAddress record);

    int insertSelective(MemberAddress record);

    List<MemberAddress> selectByExample(MemberAddressExample example);

    MemberAddress selectByPrimaryKey(Long id);

    int updateByExampleSelective(@Param("record") MemberAddress record, @Param("example") MemberAddressExample example);

    int updateByExample(@Param("record") MemberAddress record, @Param("example") MemberAddressExample example);

    int updateByPrimaryKeySelective(MemberAddress record);

    int updateByPrimaryKey(MemberAddress record);
}