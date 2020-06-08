package com.bjpowernode.crm.utils;


import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Field;

/**
 *
 */
public class RequestUtil {
    public static Object init(Class classFile, HttpServletRequest request){
        Object instance = null;
        Field fieldArray[] = null;
        String value = null;
        try {
            instance = classFile.newInstance();
            fieldArray = classFile.getDeclaredFields();
            for (Field fieldObj : fieldArray) {
               //获得属性名
                String fieldName = fieldObj.getName();
                //获得属性数据类型名
                String typeName = fieldObj.getType().getName();
                //获得属性值
                value = request.getParameter(fieldName);
                if (value == null || "".equals(value)) {
                    continue;
                }
                fieldObj.setAccessible(true);
                if ("java.lang.Integer".equals(typeName)) {
                fieldObj.set(instance, Integer.valueOf(value));
                } else if ("java.lang.String".equals(typeName)) {
                    fieldObj.set(instance, value);
                } else if ("java.lang.Double".equals(typeName)) {
                    fieldObj.set(instance, Double.valueOf(value));
                }
            }
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return instance;
    }
}
