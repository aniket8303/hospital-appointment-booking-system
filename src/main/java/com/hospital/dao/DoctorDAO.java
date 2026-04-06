package com.hospital.dao;

import com.hospital.model.Doctor;
import com.hospital.model.User;
import com.hospital.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;

public class DoctorDAO {

    public void saveDoctor(Doctor doctor) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(doctor);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public List<Doctor> getAllDoctors() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM Doctor d JOIN FETCH d.user JOIN FETCH d.department",
                Doctor.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Doctor> getDoctorsByDepartment(int deptId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Doctor> query = session.createQuery(
                "FROM Doctor d WHERE d.department.deptId = :deptId AND d.isActive = true",
                Doctor.class);
            query.setParameter("deptId", deptId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Doctor getDoctorById(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Doctor.class, doctorId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Doctor getDoctorByUserId(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Doctor> query = session.createQuery(
                "FROM Doctor d WHERE d.user.userId = :userId", Doctor.class);
            query.setParameter("userId", userId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void deleteDoctor(int doctorId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            // Delete appointments first
            session.createQuery(
                "DELETE FROM Appointment WHERE doctor.doctorId = :doctorId")
                .setParameter("doctorId", doctorId)
                .executeUpdate();
            // Delete doctor and user
            Doctor doctor = session.get(Doctor.class, doctorId);
            if (doctor != null) {
                User user = doctor.getUser();
                session.delete(doctor);
                if (user != null) session.delete(user);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
