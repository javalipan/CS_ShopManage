package com.manage.dao.model;

import java.io.Serializable;
import java.util.Date;

public class MemberAddress implements Serializable {
    /**[19 NOTNULL] id*/
    private Long id;

    /**[19 NOTNULL] 会员id */
    private Long memberid;

    /**[20 NOTNULL] 收货人姓名*/
    private String name;

    /**[10 NOTNULL] 地址id*/
    private Integer addressid;

    /**[500 NOTNULL] 详细地址*/
    private String detailaddress;

    /**[500 NOTNULL] 收货人地址*/
    private String address;

    /**[50 NOTNULL] 联系电话*/
    private String phone;

    /**[10 NOTNULL] 是否默认,0:否，1：是*/
    private String isdefault;

    /**[19 NOTNULL] 添加时间*/
    private Date createtime;

    private static final long serialVersionUID = 1L;

    /**
     * @return  Long  id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param  Long[19 NOTNULL] id
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return  Long  会员id 
     */
    public Long getMemberid() {
        return memberid;
    }

    /**
     * @param  Long[19 NOTNULL] 会员id 
     */
    public void setMemberid(Long memberid) {
        this.memberid = memberid;
    }

    /**
     * @return  String  收货人姓名
     */
    public String getName() {
        return name;
    }

    /**
     * @param  String[20 NOTNULL] 收货人姓名
     */
    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    /**
     * @return  Integer  地址id
     */
    public Integer getAddressid() {
        return addressid;
    }

    /**
     * @param  Integer[10 NOTNULL] 地址id
     */
    public void setAddressid(Integer addressid) {
        this.addressid = addressid;
    }

    /**
     * @return  String  详细地址
     */
    public String getDetailaddress() {
        return detailaddress;
    }

    /**
     * @param  String[500 NOTNULL] 详细地址
     */
    public void setDetailaddress(String detailaddress) {
        this.detailaddress = detailaddress == null ? null : detailaddress.trim();
    }

    /**
     * @return  String  收货人地址
     */
    public String getAddress() {
        return address;
    }

    /**
     * @param  String[500 NOTNULL] 收货人地址
     */
    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }

    /**
     * @return  String  联系电话
     */
    public String getPhone() {
        return phone;
    }

    /**
     * @param  String[50 NOTNULL] 联系电话
     */
    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    /**
     * @return  String  是否默认,0:否，1：是
     */
    public String getIsdefault() {
        return isdefault;
    }

    /**
     * @param  String[10 NOTNULL] 是否默认,0:否，1：是
     */
    public void setIsdefault(String isdefault) {
        this.isdefault = isdefault == null ? null : isdefault.trim();
    }

    /**
     * @return  Date  添加时间
     */
    public Date getCreatetime() {
        return createtime;
    }

    /**
     * @param  Date[19 NOTNULL] 添加时间
     */
    public void setCreatetime(Date createtime) {
        this.createtime = createtime;
    }

    @Override
    public boolean equals(Object that) {
        if (this == that) {
            return true;
        }
        if (that == null) {
            return false;
        }
        if (getClass() != that.getClass()) {
            return false;
        }
        MemberAddress other = (MemberAddress) that;
        return (this.getId() == null ? other.getId() == null : this.getId().equals(other.getId()))
            && (this.getMemberid() == null ? other.getMemberid() == null : this.getMemberid().equals(other.getMemberid()))
            && (this.getName() == null ? other.getName() == null : this.getName().equals(other.getName()))
            && (this.getAddressid() == null ? other.getAddressid() == null : this.getAddressid().equals(other.getAddressid()))
            && (this.getDetailaddress() == null ? other.getDetailaddress() == null : this.getDetailaddress().equals(other.getDetailaddress()))
            && (this.getAddress() == null ? other.getAddress() == null : this.getAddress().equals(other.getAddress()))
            && (this.getPhone() == null ? other.getPhone() == null : this.getPhone().equals(other.getPhone()))
            && (this.getIsdefault() == null ? other.getIsdefault() == null : this.getIsdefault().equals(other.getIsdefault()))
            && (this.getCreatetime() == null ? other.getCreatetime() == null : this.getCreatetime().equals(other.getCreatetime()));
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
        result = prime * result + ((getMemberid() == null) ? 0 : getMemberid().hashCode());
        result = prime * result + ((getName() == null) ? 0 : getName().hashCode());
        result = prime * result + ((getAddressid() == null) ? 0 : getAddressid().hashCode());
        result = prime * result + ((getDetailaddress() == null) ? 0 : getDetailaddress().hashCode());
        result = prime * result + ((getAddress() == null) ? 0 : getAddress().hashCode());
        result = prime * result + ((getPhone() == null) ? 0 : getPhone().hashCode());
        result = prime * result + ((getIsdefault() == null) ? 0 : getIsdefault().hashCode());
        result = prime * result + ((getCreatetime() == null) ? 0 : getCreatetime().hashCode());
        return result;
    }
}