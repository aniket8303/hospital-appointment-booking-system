package com.hospital.dao;

import com.hospital.model.Department;
import com.hospital.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class DepartmentDAO {

    public void saveDepartment(Department dept) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(dept);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public List<Department> getAllDepartments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Department", Department.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Department getDepartmentById(int deptId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Department.class, deptId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deleteDepartment(int deptId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Department dept = session.get(Department.class, deptId);
            if (dept != null) session.delete(dept);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
